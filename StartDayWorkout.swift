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
    
    
    var body: some View {
        NavigationView{
            ZStack{
                // Image of which muscle is working now
                
                Color.openGreen
                    .ignoresSafeArea()
                
                VStack(alignment: .center){
                    VStack{
                        Text("\(allExcercises.isEmpty ? "No Excersises" : allExcercises[excercisesIndex].name.uppercased())")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .foregroundColor(.black)
                        Text("\(allExcercises.isEmpty ? 0 : allExcercises[excercisesIndex].setsCount) x \(allExcercises.isEmpty ? 0 : allExcercises[excercisesIndex].repeatsCount)")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                    }
                    .offset(x:0,y: 250)
                   Spacer()
                    Spacer()
                    Spacer()
                    HStack{
                        if showEnd == false{
                            Button{
                                withAnimation {
                                    nextExcercise()
                                }
                              
                            }label: {
                                Image(systemName: "play.circle")
                                    .foregroundColor(Color.openGreen)
                                    .background(Color.black)
                                    .clipShape(Circle())
                                    .font(.system(size: 60))
                                
                            }
                        }else{
                            Button("Start Again"){
                                withAnimation {
                                    excercisesIndex = 0
                                    showEnd = false
                                }
                               
                            }
                        }
                        
                    }
                    Spacer()
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
        
        if (countOfExcercises - 1) > excercisesIndex{
            excercisesIndex += 1
        }else{
            showEnd = true
        }
    }
}

struct StartDayWorkout_Previews: PreviewProvider {
    
    static var previews: some View {
        let muscle = Muscle(muscle: "Chest", exercises: [Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 12, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4)])
        let muscle2 = Muscle(muscle: "back", exercises: [Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 12, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4)])
        StartDayWorkout(day: Day(id: 1, muscles: [muscle,muscle2]))
    }
}
