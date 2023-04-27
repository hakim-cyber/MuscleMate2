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


struct AllExcercisesView: View {
    @State private var exercises = [ExerciseApi]()
    var body: some View {
        List(exercises.filter{$0.bodyPart == "back" }) { exercise in
            VStack{
                Text(exercise.name)
                Text(exercise.bodyPart)
            }
        }
        .onAppear{
           load()
        }
    }
    func load(){
        let headers = [
            "content-type": "application/octet-stream",
            "X-RapidAPI-Key": "d3be8ad012mshea31fdf3fc52d3bp18251bjsn0ff8b0e32a60",
            "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
        ]
        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises") else{return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest){data,_,error in
            guard let data = data else{return}
            if let decoded = try?JSONDecoder().decode([ExerciseApi].self, from: data){
                DispatchQueue.main.async {
                    exercises = decoded
                }
            }
        }.resume()
    }
}

struct AllExcercisesView_Previews: PreviewProvider {
    static var previews: some View {
        AllExcercisesView()
    }
}
