//
//  AddDayView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct AddDayView: View {
    @Environment(\.dismiss) var dismiss
    @State var days = [Day]()
    
    @State var availibleDays = ["1","2","3","4","5","6","7"]
    
    @State private var dayOfWeek = "1"
    var body: some View {
        NavigationView{
        Form{
            Section("Day of Week"){
                if availibleDays.count != 0{
                    Group{
                        VStack{
                            HStack{
                                
                                Picker("",selection: $dayOfWeek){
                                    
                                    ForEach(availibleDays,id: \.self) { day in
                                        Text(CheckWeekDay(day: Int(day)!))
                                    }
                                    
                                }
                                .labelsHidden()
                                
                                Spacer()
                                Text("\(CheckWeekDay(day: Int(dayOfWeek)!))")
                                    .font(.largeTitle)
                            }
                        }
                        HStack{
                            Spacer()
                            Button("Add Day"){
                                let day = Day(id: Int(dayOfWeek)!, muscles: [Muscle]())
                                addNotification(for: Int(dayOfWeek)!)
                                withAnimation {
                                    days.append(day)
                                }
                              
                                let newAvailible =   availibleDays.filter{$0 != dayOfWeek}
                                availibleDays = newAvailible
                                
                                
                            }
                            Spacer()
                        }
                        .disabled(availibleDays.count == 0)
                    }
                }else{
                    
                }
                List(days.sorted{$0.id < $1.id}){day in
                    Text("\(CheckWeekDay(day:day.id))")
                }
            }
            .foregroundColor(Color.openGreen)
        }
        .onAppear(perform: load)
        .onChange(of: availibleDays){newArray in
            if availibleDays.count != 0{
                dayOfWeek = newArray[0]
            }else{
                
            }
        }
        .toolbar{
            Button("Done"){
                save()
                dismiss()
            }
        }
    }
}
    func save(){
        if let encoded = try? JSONEncoder().encode(days){
            UserDefaults.standard.set(encoded, forKey: Day.saveKey)
        }
    }
    func load(){
        if let data = UserDefaults.standard.data(forKey: Day.saveKey){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                days = decoded
                newAvailible()
                  
                
            }
        }
    }
    func newAvailible(){
       var  usedDays = [String]()
        for day in days{
            usedDays.append(String(day.id))
        }
        availibleDays = availibleDays.filter{!(usedDays.contains($0))}
    }
    func CheckWeekDay(day:Int) ->String{
        switch day{
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        case 7:
            return "Sunday"
       
            
        default:
            return "Day of Week"
        }
    }
    func addNotification(for day:Int){
        let center = UNUserNotificationCenter.current()
        
        var weekday = day + 1
        if day == 7{
            weekday = 0
        }
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Go for a workout at gym \(day)"
            content.body = "❝Each new day is a new oportunity to improve❞"
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 17
            dateComponents.minute = 30
            dateComponents.second = 0
            dateComponents.weekday = weekday
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           
           //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
            let request = UNNotificationRequest(identifier: "workout-\(day)", content: content, trigger:trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings{settings in
            if settings.authorizationStatus == .authorized{
                addRequest()
            }else{
                center.requestAuthorization(options: [.alert,.badge,.sound]){success , error in
                    if success{
                        addRequest()
                    }else{
                        print("\(String(describing: error?.localizedDescription))")
                    }
                }
            }
        }
    }
}

struct AddDayView_Previews: PreviewProvider {
    static var previews: some View {

            AddDayView()
                .preferredColorScheme(.dark)
        
    }
}
