//
//  DayView-ViewModel.swift
//  MuscleMate
//
//  Created by aplle on 4/28/23.
//

import Foundation
import SwiftUI


class DayView_viewModel:ObservableObject {
    @Binding var day:Day
    var change: () -> Void
    
    @Published var days = [Day]()
    
    @Published var availibleMuscles = ["back",
                                       "cardio",
                                       "chest",
                                       "lower arms",
                                       "lower legs",
                                       "neck",
                                       "shoulders",
                                       "upper arms",
                                       "upper legs",
                                       "waist"]
    @Published var pickedMuscle = "back"
    
    @Published var showadding =  false
    @Published var ShowStartWorkout = false
    
    init(day: Binding<Day>, change: @escaping () -> Void)  {
        self._day = day
        self.change = change
        
        newAvailible()
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
        change()
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
}
