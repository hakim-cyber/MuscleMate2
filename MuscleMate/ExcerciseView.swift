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
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.openGreen,lineWidth:7)
                        .frame(width: 350,height: 200)
                        .overlay(
                            VStack{
                                    Text(excersise.name.uppercased())
                                        .padding()
                                        .font(.headline)
                                        .bold()
                                   
                                Spacer()
                                
                                Text("\(excersise.setsCount ) x \(excersise.repeatsCount)")
                                    .padding()
                                    .font(.largeTitle)
                                Spacer()
                            }
                            
                        )
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
            ExcerciseView(muscle: Muscle(muscle: "Chest", exercises: [Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4)]))
                .preferredColorScheme(.dark)
        }
    }
}
