//
//  ContentView-ViewModel.swift
//  MuscleMate
//
//  Created by aplle on 4/30/23.
//

import Foundation

//
//  ContentView-ViewModel.swift
//  MuscleMate
//
//  Created by aplle on 4/28/23.
//

import Foundation
import SwiftUI
import UserNotifications
import CoreData


class ContentView_ViewModel:ObservableObject{
    @Published var daysOfWeek = [Day]()
    
    @Published var showAdd = false
    @Published var madeDays = [Day]()
    
    @Published var todayString = ""
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var cashedDays:FetchedResults<CashedDay>
   
    func defineTodayString(){
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        
        todayString = weekdays[weekday - 1]
    }
    func calculateCountOfExcercises(day:Day)->Int{
        var count = 0
        
        for muscle in day.muscles{
            count += muscle.exercises.count
        }
        return count
        
             
        
    }
    
    func load(){
        if let data = UserDefaults.standard.data(forKey: Day.saveKey){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                daysOfWeek = decoded
            }
        }
    }
    
    func save(){
        if let encoded = try? JSONEncoder().encode(daysOfWeek){
            UserDefaults.standard.set(encoded, forKey: Day.saveKey)
        }
    }
    func saveCoreData() async{
        await MainActor.run {
            for day in daysOfWeek{
                let newDay = CashedDay(context: moc)
                newDay.id = Int16(day.id)
                
                var arrayMuscles = Set<CashedMuscle>()
                
                for muscle in day.muscles{
                    let newMuscle = CashedMuscle(context: moc)
                    newMuscle.muscle = muscle.muscle
                    newMuscle.id = muscle.id
                
                    var arrayExcercise = Set<CashedExcercise>()
                    
                    for excercise in muscle.exercises{
                        let newExercise = CashedExcercise(context: moc)
                        newExercise.id = excercise.id
                        newExercise.bodyPart = excercise.bodyPart
                        newExercise.equipment = excercise.equipment
                        newExercise.gifUrl = excercise.gifUrl
                        newExercise.name = excercise.name
                        newExercise.repeatsCount = Int16(excercise.repeatCount!)
                        newExercise.setsCount = Int16(excercise.sets!)
                        newExercise.target = excercise.target
                        
                        arrayExcercise.insert(newExercise)
                    }
                    newMuscle.exercise = arrayExcercise as NSSet
                    
                    arrayMuscles.insert(newMuscle)
                }
                newDay.muscle = arrayMuscles as NSSet
                           
                do{
                    
                    try moc.save()
                }catch{
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    func remove(_ index: Int){
        let center = UNUserNotificationCenter.current()
        
        let identifier = "workout-\(daysOfWeek[index].id)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
            daysOfWeek.remove(at: index)
            save()
        }
    
    func loadMadeDays(){
        let saveKeyMade = "Made"
        
        if let data = UserDefaults.standard.data(forKey: saveKeyMade){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                madeDays = decoded
            }
         }
    }
    
    func checkIsMade(day:Day)-> Bool{
        if madeDays.contains(where: {$0.id == day.id}){
            return true
        }else{
            return false
        }
            
    }
    func CheckWeekDay(day:Day) ->String{
        switch day.id{
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        case 7:
            return "Sunday"
       
            
        default:
            return "Day of Week"
        }
    }
    
    func checkToday(day:String)->Bool{
        if day == todayString{
            return true
        }else{
            return false
        }
    }
    
    func loadAllExcercises(){
        let saveKeyExercises = "exercises"
        var exercises = [ExerciseApi]()
        
        if let savedData = UserDefaults.standard.data(forKey: saveKeyExercises){
            // if value nothing to do
        }else{
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
                        print(exercises.first?.name)
                        if let encoded = try? JSONEncoder().encode(exercises){
                            UserDefaults.standard.set(encoded, forKey: saveKeyExercises)
                        }
                    }
                    
                }
            }.resume()
            
        }
    }
    
    
    
}
