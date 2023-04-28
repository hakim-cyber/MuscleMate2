//
//  AllExcercisesView.swift
//  MuscleMate
//
//  Created by aplle on 4/27/23.
//

import SwiftUI


    struct ExerciseApi: Codable,Identifiable,Hashable{
        let bodyPart:String
        let equipment:String
        let gifUrl:String
        let id:String
        let name:String
        let target:String
        
        var sets:Int? = 0
        var repeatCount:Int? = 0
        
        static var defaultExercise = ExerciseApi(bodyPart: "Back", equipment: "Dumbell", gifUrl: "sdssdsdsd", id: "001", name: "Dumbell Press", target: "back")
       
        func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
    }
/*
bodyPart:"waist"
equipment:"body weight"
gifUrl:"http://d205bpvrqc9yn1.cloudfront.net/0001.gif"
id:"0001"
name:"3/4 sit-up"
target:"abs"
 */
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


