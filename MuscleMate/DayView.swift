//
//  DayView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI

struct DayView: View {
    @Binding var day:Day
    var change: (() -> Void)? = nil
    @State var days = [Day]()
    var body: some View {
        
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(day.muscles){muscle in
                        NavigationLink(destination:ExcerciseView(muscle: muscle).preferredColorScheme(.dark) ){
                            
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.openGreen,lineWidth:7)
                                .frame(width: 350,height: 200)
                                .overlay(
                                    VStack{
                                        HStack{
                                            Text("\(muscle.muscle)")
                                                .padding()
                                                .font(.largeTitle)
                                                .bold()
                                                .foregroundColor(.white)
                                            Spacer()
                                            VStack(alignment: .trailing){
                                                ForEach(muscle.exercises){excercise in
                                                    Text(excercise.name.uppercased())
                                                        .foregroundColor(.white)
                                                }
                                                .padding()
                                            }
                                        }
                                        
                                    }
                                    
                                )
                        }
                    }
                }
                .padding(40)
            }
            .toolbar{
                Button("add muscle"){
                    let newMuscle = Muscle(muscle: "Back", exercises: [Exercise]())
                    
                    day.muscles.append(newMuscle)
                    self.change?()
                }
            }
        
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


