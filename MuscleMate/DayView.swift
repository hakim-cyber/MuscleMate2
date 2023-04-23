//
//  DayView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI

struct DayView: View {
    @Binding var day:Day
    var change: (() -> Void)? = nil
    @State var days = [Day]()
    
    @State var availibleMuscles = ["abdominals",
                                   "abductors",
                                   "adductors",
                                  "biceps",
                                   "calves",
                                   "chest",
                                   "forearms",
                                   "glutes",
                                   "hamstrings",
                                   "lats",
                                   "lower_back",
                                   "middle_back",
                                   "neck",
                                   "quadriceps",
                                   "traps",
                                   "triceps"]
    @State var pickedMuscle = "glutes"
    
    @State var showadding =  false
    var body: some View {
        VStack{
            if showadding{
                HStack{
                    
                    Picker("",selection: $pickedMuscle){
                        
                        ForEach(availibleMuscles,id: \.self) { muscle in
                            Text(muscle.uppercased())
                                .foregroundColor(Color.openGreen)
                        }
                        
                    }
                    
                    .labelsHidden()
                    .padding()
                    
                    Spacer()
                    Text("\(pickedMuscle.uppercased())")
                        .font(.largeTitle)
                        .padding()
                }
                .foregroundColor(Color.openGreen)
                HStack{
                    Spacer()
                    Button("Add Muscle"){
                        let muscle = Muscle(muscle: pickedMuscle.uppercased(), exercises: [Exercise]())
                        day.muscles.append(muscle)
                        self.change?()
                        let newAvailible =   availibleMuscles.filter{$0 != pickedMuscle}
                        availibleMuscles = newAvailible
                        
                    }
                    Spacer()
                }
            }
            
            ScrollView{
                
                
                
                VStack(alignment: .leading){
                    ForEach(Array(day.muscles.indices),id:\.self){index in
                        NavigationLink(destination:ExcerciseView(muscle: $day.muscles[index]){
                            self.change?()
                        }.preferredColorScheme(.dark) ){
                            
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.openGreen,lineWidth:7)
                                .frame(width: 350,height: 200)
                                .overlay(
                                    VStack{
                                        HStack{
                                            Text("\(day.muscles[index].muscle)")
                                                .padding()
                                                .font(.largeTitle)
                                                .bold()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                            Spacer()
                                            VStack(alignment: .trailing){
                                                ForEach(day.muscles[index].exercises){excercise in
                                                    Text(excercise.name.uppercased())
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                                            }
                                        }
                                        
                                    }
                                    
                                )
                        }
                    }
                }
                .padding(40)
            }
        }
            .toolbar{
                Button{
                    withAnimation {
                        showadding.toggle()
                    }
                   
                   
                }label:{
                
                    if showadding == false{
                        Image(systemName: "plus.circle")
                    }else{
                        Image(systemName: "minus.circle")
                    }
                }
                .foregroundColor(Color.openGreen)
            }
        
    }
    func load(){
        if let data = UserDefaults.standard.data(forKey: Day.saveKey){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                days = decoded
                
                  
                
            }
        }
    }
    func save(){
        if let encoded = try? JSONEncoder().encode(days){
            UserDefaults.standard.set(encoded, forKey: Day.saveKey)
        }
    }
}

struct DayView_Previews: PreviewProvider {
    @State static var day = Day(id: 4, muscles: [Muscle(muscle: "Back", exercises: [Exercise(name: "Bench Press", repeatsCount: 12, setsCount: 4)])])
    
    static var previews: some View {
        NavigationView{
            DayView(day: $day)
                .preferredColorScheme(.dark)
        }
    }
}


