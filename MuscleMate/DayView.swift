//
//  DayView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI

struct DayView: View {
    let day:Day
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
        
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DayView(day: Day(id: 4, muscles: [Muscle(muscle: "Back", exercises: [Exercise(name: "Bench Press", repeatsCount: 12, setsCount: 4)])]))
                .preferredColorScheme(.dark)
        }
    }
}

