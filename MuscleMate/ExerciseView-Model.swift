//
//  ExerciseView-Model.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//

import Foundation
import SwiftUI

class ExerciseView_Model:ObservableObject{
    @Binding var muscle:Muscle
    var change: ()->Void
    
    @Published var showadding =  false
   
    @Published var pickedExcerciseTry = 0
    @Published var setsCount = 1
    @Published var repeatsCount = 1
    
    @Published var exercisesForThisMuscle = [ExerciseApi]()
    
    
    init(muscle:Binding<Muscle>, change:@escaping ()->Void){
        self._muscle = muscle
        self.change = change
    }
    
    func remove(index:Int){
        muscle.exercises.remove(at: index)
        change()
    }
    func loadExercises(){
        let saveKeyExercises = "exercises"
        
        if let data = UserDefaults.standard.data(forKey: saveKeyExercises){
            if let decoded = try? JSONDecoder().decode([ExerciseApi].self, from: data){
                exercisesForThisMuscle = decoded.filter{$0.bodyPart == muscle.muscle.lowercased()}
                
            }
        }
    }
}
