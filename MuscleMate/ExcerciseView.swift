//
//  ExcerciseView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct ExcerciseView: View {
    let muscle:Muscle
    var body: some View {

            ScrollView{
                ForEach(muscle.exercises){excersise in
                    HStack{
                        let index = muscle.exercises.firstIndex(of:excersise)
                        Image(systemName: "\((index ?? 0) + 1).circle")
                            .font(.headline)
                            .foregroundColor(Color.openGreen)
                            .padding(4)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.openGreen,lineWidth:7)
                        .frame(width: 350,height: 100)
                        .overlay(
                            HStack{
                                Text("\(excersise.name.uppercased())")
                                    .font(.headline)
                                    .padding()
                                    .bold()
                                Spacer()
                                
                                Text("\(excersise.setsCount) x \(excersise.repeatsCount)")
                                    .padding(25)
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                
                                
                            }
                        )
                }
                 
                }
                .padding(40)
            }
            .navigationTitle("\(muscle.muscle)")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct ExcerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ExcerciseView(muscle: Muscle(muscle: "Chest", exercises: [Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4)]))
                .preferredColorScheme(.dark)
        }
    }
}
