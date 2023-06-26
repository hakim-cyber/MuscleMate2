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
    @State private var screen = UIScreen.main.bounds
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
                    .offset(x:0,y: 150)
      
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
                                            
                                            VStack(spacing: 50){
                                                RoundedRectangle(cornerRadius: 15)
                                                      .fill(Color.openGreen)
                                                      .frame(width: screen.width / 1.15,height: screen.height / 9)
                                                      .shadow(color: Color.openGreen,radius: 15)
                                                      .overlay(
                                                          HStack{
                                                             
                                                                  Text("\(allExcercises.isEmpty ? 0 : allExcercises[excercisesIndex].repeatCount!) x \(!allExcercises.isEmpty ?  allExcercises[excercisesIndex].sets!:0) ")
                                                                      .foregroundColor(.black)
                                                                      .font(.system(.largeTitle,design: .rounded))
                                                                      .padding(.horizontal,30)
                                                                 
                                                                  Divider()
                                                                      .bold()
                                                                     
                                                                  
                                                              VStack(alignment: .center){
                                                                  Text( "\(!allExcercises.isEmpty ?  allExcercises[excercisesIndex].equipment.uppercased() :"")")
                                                                      .foregroundColor(.black)
                                                                      .font(.system(.headline,design: .serif))
                                                                      .padding(.horizontal,20)
                                                                  Text("\(!allExcercises.isEmpty ?  allExcercises[excercisesIndex].target.uppercased() : "")")
                                                                      .foregroundColor(.black)
                                                                      .font(.system(.headline,design: .serif))
                                                                      .padding(.horizontal,20)
                                                                      .padding(.vertical,5)
                                                              }
                                                          }
                                                          ,alignment:.center)
                                                      .padding(.vertical,10)
                                                    
                                                
                                                
                                                
                                             
                                                ProgressView(value: Float(excercisesIndex),total:Float(allExcercises.count))
                                                    .scaleEffect(1.5, anchor: .center)
                                                .padding(.horizontal,16)
                                                .tint(Color.openGreen)
                                                .shadow(color: Color.openGreen,radius: 10)
                                                    if !startRest{
                                                    
                                                            Image(systemName: "play.circle")                                                          .foregroundColor(Color.openGreen)
                                                                .background(Color.black)
                                                                .clipShape(Circle())
                                                                .font(.system(size: 80))
                                                                .padding()
                                                                .padding(.bottom)
                                                               
                                                        
                                                        
                                                    }else{
                                                      Image(systemName: "stop.circle")
                                                            .foregroundColor(Color.openGreen)
                                                            .background(Color.black)
                                                            .clipShape(Circle())
                                                            .font(.system(size: 80))
                                                            .padding()
                                                            .padding(.bottom)
                                                       
                                                        
                                                        
                                                        
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
                    .background(Color.black)
                    .background(Color.openGreen)
                    .roundedCorner(25, corners: [.topLeft,.topRight])
                    .frame(width: screen.width / 1,height: screen.height / 2.4)
                   
                  
                   
                }
                .ignoresSafeArea()
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
            .ignoresSafeArea()
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
                            .foregroundColor(.black)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    HStack{
                        Image(systemName: "flame.circle.fill")
                            .foregroundColor(.orange)
                        Text("\(estimatedCalories) KCAL")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
            
        }
        .ignoresSafeArea()
       
    }
    var estimatedTimeForWorkout:Int{
        var setsCount = 0
        for muscle in day.muscles {
            for excercise in muscle.exercises{
                setsCount += excercise.sets!
            }
        }
        
        let estimatedTime = setsCount * 120 + (setsCount - 1) * 120
        if estimatedTime > 0{
            return estimatedTime
        }else{
            return 0
        }
    }
    var estimatedCalories:String{
        var estimatedInHours = Double(estimatedTimeForWorkout) / 3600
        return String(format: "%.1f", estimatedInHours * 300)
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
      
       
        
        print("before index \(excercisesIndex)")
       
            if (countOfExcercises) != excercisesIndex{
                setsCountRemaining -= 1
                if setsCountRemaining == 0 {
                    if !showEnd{
                        if (countOfExcercises) != excercisesIndex + 1{
                            excercisesIndex += 1
                        }else{
                            showEnd = true
                            checkAsMade()
                        }
                    }
                }
                
            }else{
               
                showEnd = true
                checkAsMade()
            }
        print("After index \(excercisesIndex)")
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
