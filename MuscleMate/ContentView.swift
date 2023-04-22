//
//  ContentView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI


struct ContentView: View {
    let daysOfWeek = [Day(id: 1, muscles: [Muscle](arrayLiteral: Muscle(muscle: "Back", exercises: [Exercise]()), Muscle(muscle: "Back", exercises: [Exercise]())
                                                  )),
                     Day(id: 2, muscles: [Muscle]()),
                     Day(id: 3, muscles: [Muscle]()),
                     Day(id: 4, muscles: [Muscle]())]
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                ForEach(daysOfWeek) { day in
                    
                    NavigationLink{
                        
                    }label: {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.openGreen)
                            .frame(width: 350,height: 100)
                            .overlay(
                                VStack{
                                    Spacer()
                                    HStack{
                                        Text("Day \(day.id)")
                                            .foregroundColor(.black)
                                            .font(.largeTitle)
                                            .bold()
                                        Spacer()
                                        VStack{
                                            ForEach(day.muscles){muscle in
                                                Text("\(muscle.muscle)")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                    .padding()
                            )
                    }
                        
                }
            }
            .toolbar{
                Button{
                    // Add day view
                }label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.openGreen)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
