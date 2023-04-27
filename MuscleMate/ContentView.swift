//
//  ContentView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var  daysOfWeek = [Day]()
    

    @State var showAdd = false
    @State var madeDays = [Day]()
    
    @State var  todayString = ""
    
    let DailyTimer = Timer.publish(every: 86400, on: .current, in: .common).autoconnect()
    let weeklyTimer = Timer.publish(every: 86400 * 7, on: .current, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(Array(daysOfWeek.indices).sorted{daysOfWeek[$0].id < daysOfWeek[$1].id  } , id:\.self) { index in
                        
                        NavigationLink(destination:DayView(day: $daysOfWeek[index]){
                            save()
                            load()
                        }.preferredColorScheme(.dark) ){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(checkToday(day: CheckWeekDay(day: daysOfWeek[index])) ? Color.underlinedGreen : Color.openGreen)
                                .frame(width: 400,height: 150)
                                .overlay(
                                    VStack{
                                        Button(action: {
                                            remove(index)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                            
                                            
                                        }
                                        .padding()
                                        .background(checkToday(day: CheckWeekDay(day: daysOfWeek[index])) ? Color.underlinedGreen : Color.openGreen)
                                        .cornerRadius(15)
                                        
                                       
                                        if checkIsMade(day: daysOfWeek[index]){
                                            Image(systemName: "checkmark.seal.fill")
                                                .padding(.vertical,10)
                                        }else{
                                            Image(systemName: "xmark.seal.fill")
                                                .foregroundColor(.red)
                                                .padding(.vertical,10)
                                        }
                                    }
                                                                    
                                                                        , alignment: .leading)
                              
                                .overlay(
                                    VStack{
                                        
                                        HStack{
                                            Spacer()
                                            Text("\(CheckWeekDay(day:daysOfWeek[index]))")
                                                .foregroundColor(.black)
                                                .font(.system(.largeTitle,design: .serif))
                                                .bold()
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(.black)
                                              
                                        
                                        }
                                 Spacer()
                                        Text("\(calculateCountOfExcercises(day:daysOfWeek[index])) Excersices")
                                            .foregroundColor(.black.opacity(0.9))
                                            
                                    }
                                        .padding()
                                )
                                
                                                                    
                        }
                        
                    }
                    .onReceive(DailyTimer){_ in
                        let calendar = Calendar.current
                        let today = Date()
                        let weekday = calendar.component(.weekday, from: today)
                        
                        let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
                        
                        todayString = weekdays[weekday - 1]
                    }
                    .onReceive(weeklyTimer){_ in
                        let EmptyMadeArray = [Day]()
                        let saveKeyMade = "Made"
                        
                        if let encoded = try? JSONEncoder().encode(EmptyMadeArray){
                            UserDefaults.standard.setValue(encoded, forKey: saveKeyMade)
                        }
                        loadMadeDays()
                    }
                    .onAppear{
                        let calendar = Calendar.current
                        let today = Date()
                        let weekday = calendar.component(.weekday, from: today)
                        
                        let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
                        
                        todayString = weekdays[weekday - 1]
                    }
                   
                }
                .padding(40)
                
            }
            .sheet(isPresented: $showAdd,onDismiss: load){
                AddDayView()
                    .preferredColorScheme(.dark)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                        Button {
                            withAnimation {
                                showAdd = true
                            }
                            
                        }label:{
                            Image(systemName: "plus")
                                .foregroundColor(Color.openGreen)
                                .font(.headline)
                                .padding()
                        }
                        
                        
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 30))
                        
                    }
                
                            }
            .onAppear{
                load()
                loadMadeDays()
                loadAllExcercises()
            }
            .preferredColorScheme(.dark)
                           
            
        }
    }
    
    func calculateCountOfExcercises(day:Day)->Int{
        var count = 0
        
        for muscle in day.muscles{
            count += muscle.exercises.count
        }
        return count
        
    }
    func load(){
        if let data = UserDefaults.standard.data(forKey: Day.saveKey){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                daysOfWeek = decoded
            }
        }
    }
    
    func save(){
        if let encoded = try? JSONEncoder().encode(daysOfWeek){
            UserDefaults.standard.set(encoded, forKey: Day.saveKey)
        }
    }
    
    func remove(_ index: Int){
        let center = UNUserNotificationCenter.current()
        
        let identifier = "workout-\(daysOfWeek[index].id)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
            daysOfWeek.remove(at: index)
            save()
        
       
        }
    
    
    func loadMadeDays(){
        let saveKeyMade = "Made"
        
        if let data = UserDefaults.standard.data(forKey: saveKeyMade){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                madeDays = decoded
            }
         }
    }
    func checkIsMade(day:Day)-> Bool{
        if madeDays.contains(where: {$0.id == day.id}){
            return true
        }else{
            return false
        }
            
    }
    
    
    
    
    func CheckWeekDay(day:Day) ->String{
        switch day.id{
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
    func checkToday(day:String)->Bool{
        if day == todayString{
            return true
        }else{
            return false
        }
    }
    func loadAllExcercises(){
        let saveKeyExercises = "exercises"
        var exercises = [ExerciseApi]()
        
        if let savedData = UserDefaults.standard.data(forKey: saveKeyExercises){
            // if value nothing to do
        }else{
            let headers = [
                "content-type": "application/octet-stream",
                "X-RapidAPI-Key": "d3be8ad012mshea31fdf3fc52d3bp18251bjsn0ff8b0e32a60",
                "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
            ]
            
            guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises") else{return}
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            
            
            
            URLSession.shared.dataTask(with: request as URLRequest){data,_,error in
                guard let data = data else{return}
                if let decoded = try?JSONDecoder().decode([ExerciseApi].self, from: data){
                    DispatchQueue.main.async {
                        exercises = decoded
                        print(exercises.first?.name)
                        if let encoded = try? JSONEncoder().encode(exercises){
                            UserDefaults.standard.set(encoded, forKey: saveKeyExercises)
                        }
                    }
                    
                }
            }.resume()
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
