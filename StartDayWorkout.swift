//
//  StartDayWorkout.swift
//  MuscleMate
//
//  Created by aplle on 4/24/23.
//

import SwiftUI

struct StartDayWorkout: View {
    let day:Day
    
    @State var showEnd = false
    @State var excercisesIndex = 0
    
    @Environment(\.presentationMode) var presentationMode
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemainingRest = 150
    @State var startRest = false
    @State var setsCountRemaining = 4
    
    var body: some View {
        NavigationView{
            ZStack{
                // Image of which muscle is working now
           
                Color.openGreen
                    .edgesIgnoringSafeArea(.all)
             
               
                VStack(alignment: .center){
                    VStack{
                        if !showEnd{
                            if !startRest{
                                Text("\(allExcercises.isEmpty ? "No Excersises" : allExcercises[excercisesIndex].name.uppercased())")
                                    .font(.system(.largeTitle,design: .serif))
                                    .bold()
                                    .padding()
                                    .foregroundColor(.black)
                               
                                
                            }else{
                                Text("\(timeRemainingRest)")
                                    .font(.system(size: 60))
                                    .bold()
                                    .padding()
                                    .foregroundColor(.black)
                            }
                        }else{
                            
                            Text("You Finished Workout :)")
                                .font(.system(size: 30))
                                .bold()
                                .padding()
                                .foregroundColor(.black)
                        }
                    }
                    .offset(x:0,y: 200)
      
                  Spacer()
                  
                    HStack{
                        if showEnd == false{
                            VStack{
                             
                                HStack{
                                    
                                        Button{
                                            withAnimation {
                                                if timeRemainingRest == 0{
                                                    startRest = false
                                                }else{
                                                    startRest.toggle()
                                                }
                                              
                                              
                                                if startRest == false{
                                                    nextExcercise()
                                                    timeRemainingRest = 150
                                                }
                                            }
                                            
                                        }label: {
                                            VStack{
                                              
                                                    if !startRest{
                                                        Image(systemName: "play.circle")
                                                            .padding(10)
                                                            .foregroundColor(Color.openGreen)
                                                            .background(Color.black)
                                                            .clipShape(Circle())
                                                            .font(.system(size: 80))
                                                            .padding()
                                                        
                                                        Text("Next")
                                                            .foregroundColor(Color.openGreen)
                                                    }else{
                                                      Image(systemName: "stop.circle")
                                                            .padding(10)
                                                            .foregroundColor(Color.openGreen)
                                                            .background(Color.black)
                                                            .clipShape(Circle())
                                                            .font(.system(size: 80))
                                                            .padding()
                                                        Text("Stop Rest")
                                                            .foregroundColor(Color.openGreen)
                                                    }
                                                
                                            }
                                        }
                                  
                                }
                               
                            }
                            .onReceive(timer) { time in
                                guard startRest else { return }
                                
                                if timeRemainingRest > 0 {
                                    timeRemainingRest -= 1
                                }
                            }
                            .onChange(of: timeRemainingRest){new in
                                if new == 0 {
                                    startRest = false
                                }
                            }
                        }else{
                            Button("Start Again"){
                                withAnimation {
                                    excercisesIndex = 0
                                    showEnd = false
                                }
                               
                            }
                            .padding()
                        }
                        
                    }
                    .frame(width: 390,height: 300)
                    .background(Color.black)
                    .background(Color.openGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                    Text("Reps \(allExcercises.isEmpty ? 0 : allExcercises[excercisesIndex].repeatCount!)")
                        .padding()
                        .foregroundColor(Color.openGreen)
                        .font(.system(size: 25))
                        .bold()
                        ,alignment:.topLeading)
                    .overlay(
                        Text("Set \((!allExcercises.isEmpty) ?  allExcercises[excercisesIndex].sets! - setsCountRemaining + 1 : 0) / \((!allExcercises.isEmpty) ? allExcercises[excercisesIndex].sets! : 0)")
                        .padding()
                        .foregroundColor(Color.openGreen)
                        .font(.system(size: 25))
                        .bold()
                        ,alignment:.topTrailing)
                    .padding(.vertical,30)
                 
                   
                }
                .onAppear{
                    if (!allExcercises.isEmpty){
                        setsCountRemaining = allExcercises[excercisesIndex].sets!
                    }
                }
                .onChange(of: excercisesIndex){new in
                    if (!allExcercises.isEmpty){
                        setsCountRemaining = allExcercises[new].sets!
                    }
                }
                
            }
            .navigationBarTitle(Text("\(day.muscles.isEmpty ? "No muscle" : day.muscles[muscleWorkingNowIndex].muscle.uppercased())"))
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                      
                    }label: {
                        Label("Quit", systemImage: "arrow.left")
                            .labelStyle(.titleAndIcon)
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
       
    }
    
    var allExcercises:[ExerciseApi]{
        let muscles = day.muscles
        var excercises = [ExerciseApi]()
        for muscle in muscles {
            for excercise in muscle.exercises {
                excercises.append(excercise)
            }
        }
      
        return excercises
    }
    var muscleWorkingNowIndex:Int{
        if !day.muscles.isEmpty && !allExcercises.isEmpty{
           return day.muscles.firstIndex(where: {($0.exercises.contains(self.allExcercises[excercisesIndex]))}) ?? 0
        }else{
            return 0
        }
        
    }
    func nextExcercise(){
        let countOfExcercises = allExcercises.count
      
        setsCountRemaining -= 1
       
            if (countOfExcercises - 1) != excercisesIndex{
                if setsCountRemaining == 0 {
                    if !showEnd{
                        excercisesIndex += 1
                    }
                }
                
            }else{
               
                showEnd = true
                checkAsMade()
            }
        
    }
    var excercisesRemaining:Int{
        let all = allExcercises.count
        let nowOn = excercisesIndex + 1
        return all - nowOn
    }
    
    func checkAsMade(){
        var madeArray = [Day]()
        let saveKeyMade = "Made"
        
       if let data = UserDefaults.standard.data(forKey: saveKeyMade){
           if let decoded = try? JSONDecoder().decode([Day].self, from: data){
               madeArray = decoded
           }
        }
        madeArray.append(day)
        if let encoded = try? JSONEncoder().encode(madeArray){
            UserDefaults.standard.set(encoded, forKey: saveKeyMade)
        }
        
        
    }
}

struct StartDayWorkout_Previews: PreviewProvider {
  
    static var previews: some View {
        let muscle = Muscle(muscle: "Chest", exercises: [ExerciseApi.defaultExercise])
      
        StartDayWorkout(day: Day(id: 1, muscles: [muscle]))
    }
}
