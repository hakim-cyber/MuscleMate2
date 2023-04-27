//
//  DayView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI
/*
 "back",
   "cardio",
   "chest",
   "lower arms",
   "lower legs",
   "neck",
   "shoulders",
   "upper arms",
   "upper legs",
   "waist"
 */

struct DayView: View {
    @Binding var day:Day
    var change: (() -> Void)? = nil
    @State var days = [Day]()
    
    @State var availibleMuscles = ["back",
                                   "cardio",
                                   "chest",
                                   "lower arms",
                                   "lower legs",
                                   "neck",
                                   "shoulders",
                                   "upper arms",
                                   "upper legs",
                                   "waist"]
    @State var pickedMuscle = "back"
    
    @State var showadding =  false
    @State var ShowStartWorkout = false
    var body: some View {
        VStack{
            if showadding{
                if availibleMuscles.count != 0{
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
                            .font(.system(size: 20))
                            .padding()
                    }
                    .foregroundColor(Color.openGreen)
                    HStack{
                        Spacer()
                        Button("Add Muscle"){
                            let muscle = Muscle(muscle: pickedMuscle.uppercased(), exercises: [Exercise]())
                            withAnimation {
                                day.muscles.append(muscle)
                                
                            }
                            self.change?()
                            
                            let newAvailible =   availibleMuscles.filter{$0 != pickedMuscle}
                            availibleMuscles = newAvailible
                            
                        }
                        Spacer()
                    }
                    .onChange(of: availibleMuscles){newArray in
                        if !newArray.isEmpty{
                            pickedMuscle = newArray[0]
                        }
                    }
                }else{
                    Text("All availible muscles used")
                        .font(.largeTitle)
                        .foregroundColor(Color.openGreen)
                }
            }
               
            
            ScrollView{
                
                
                
                VStack(alignment: .leading){
                    ForEach(Array(day.muscles.indices),id:\.self){index in
                        NavigationLink(destination:ExcerciseView(muscle: $day.muscles[index]){
                            self.change?()
                        }.preferredColorScheme(.dark) ){
                            HStack{
                                Button(action: {
                                    remove(index: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal,5)
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.openGreen,lineWidth:7)
                                    .frame(width: 350,height: 130)
                                
                                
                                    .overlay(
                                        VStack{
                                            
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Spacer()
                                                    Text("\(day.muscles[index].muscle)")
                                                        .foregroundColor(.white)
                                                        .font(.system(.largeTitle,design: .serif))
                                                        .bold()
                                                    Spacer()
                                                    
                                                }
                                                Spacer()
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.white)
                                                
                                                
                                            }
                                            Spacer()
                                            Text("\(day.muscles[index].exercises.count) Excersices")
                                                .foregroundColor(.white)
                                                .font(.system(.callout,design: .rounded))
                                        }
                                            .padding()
                                        
                                    )
                            }
                        }
                        .padding(5)
                    }
                }
                .padding(40)
            }
        }
        .fullScreenCover(isPresented: $ShowStartWorkout){
            StartDayWorkout(day: day)
                .preferredColorScheme(.light)
        }
            .toolbar{
                HStack{
                    Text("~\(estimatedTimeForWorkout / 60) mins")
                        .foregroundColor(.gray)
                    Button{
                        withAnimation{
                            ShowStartWorkout = true
                        }
                    }label:{
                        Label("Start",systemImage: "play.circle")
                            .labelStyle(.titleAndIcon)
                            .foregroundColor(Color.openGreen)
                    }
                    .disabled(day.muscles.isEmpty)
                  
                    
                    
                }
                .padding()
               
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
            
            .onAppear(perform:newAvailible)
        
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
    func newAvailible(){
       var  usedMuscles = [String]()
        for muscle in day.muscles{
            usedMuscles.append(muscle.muscle.lowercased())
        }
        availibleMuscles = availibleMuscles.filter{!(usedMuscles.contains($0))}
        if !availibleMuscles.isEmpty{
            pickedMuscle = availibleMuscles[0]
        }
    }
    func remove(index:Int){
        day.muscles.remove(at: index)
        change?()
    }
    var estimatedTimeForWorkout:Int{
        var setsCount = 0
        for muscle in day.muscles {
            for excercise in muscle.exercises{
                setsCount += excercise.setsCount
            }
        }
       var estimatedTime = setsCount * 120 + (setsCount - 1) * 120
        
        return estimatedTime
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


