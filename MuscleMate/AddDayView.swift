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
                                        Text(day)
                                    }
                                    
                                }
                                .labelsHidden()
                                
                                Spacer()
                                Text(" Day \(dayOfWeek)")
                                    .font(.largeTitle)
                            }
                        }
                        HStack{
                            Spacer()
                            Button("Add Day"){
                                let day = Day(id: Int(dayOfWeek)!, muscles: [Muscle]())
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
                    Text(" Day \(day.id)")
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
}

struct AddDayView_Previews: PreviewProvider {
    static var previews: some View {

            AddDayView()
                .preferredColorScheme(.dark)
        
    }
}
