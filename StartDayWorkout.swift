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
                                    .font(.system(size: 30))
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
                    Text("Reps \(allExcercises.isEmpty ? 0 : allExcercises[excercisesIndex].repeatsCount)")
                        .padding()
                        .foregroundColor(Color.openGreen)
                        .font(.system(size: 25))
                        .bold()
                        ,alignment:.topLeading)
                    .overlay(
                        Text("Set \(allExcercises[excercisesIndex].setsCount - setsCountRemaining + 1) / \(allExcercises[excercisesIndex].setsCount)")
                        .padding()
                        .foregroundColor(Color.openGreen)
                        .font(.system(size: 25))
                        .bold()
                        ,alignment:.topTrailing)
                    .padding(.vertical,30)
                 
                   
                }
                .onAppear{
                    setsCountRemaining = allExcercises[excercisesIndex].setsCount
                }
                .onChange(of: excercisesIndex){new in
                    setsCountRemaining = allExcercises[new].setsCount
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
    
    var allExcercises:[Exercise]{
        let muscles = day.muscles
        var excercises = [Exercise]()
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
            }
        
    }
    var excercisesRemaining:Int{
        let all = allExcercises.count
        let nowOn = excercisesIndex + 1
        return all - nowOn
    }
}

struct StartDayWorkout_Previews: PreviewProvider {
  
    static var previews: some View {
        let muscle = Muscle(muscle: "Chest", exercises: [Exercise(name: "bench Press", repeatsCount: 12, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 10, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 11, setsCount: 4)])
      
        StartDayWorkout(day: Day(id: 1, muscles: [muscle]))
    }
}
