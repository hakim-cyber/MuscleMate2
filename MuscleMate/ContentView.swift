//
//  ContentView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI


struct ContentView: View {
    let daysOfWeek = [Day(id: 1, muscles: [Muscle](arrayLiteral: Muscle(muscle: "Back", exercises: [Exercise]()), Muscle(muscle: "Back", exercises: [Exercise(name: "H", repeatsCount: 5, setsCount: 15)])
                                                  )),
                     Day(id: 2, muscles: [Muscle]()),
                     Day(id: 3, muscles: [Muscle]()),
                     Day(id: 4, muscles: [Muscle]())]
    
    @State var showAdd = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(daysOfWeek) { day in
                        
                        NavigationLink(destination:DayView(day: day).preferredColorScheme(.dark) ){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.openGreen)
                                .frame(width: 350,height: 150)
                                .overlay(
                                    VStack{
                                        
                                        HStack{
                                            Spacer()
                                            Text("Day \(day.id)")
                                                .foregroundColor(.black)
                                                .font(.largeTitle)
                                                .bold()
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(.black)
                                              
                                        
                                        }
                                 Spacer()
                                        Text("\(calculateCountOfExcercises(day:day)) Excersices")
                                            .foregroundColor(.black.opacity(0.9))
                                            
                                    }
                                        .padding()
                                )
                        }
                        
                    }
                }
                .padding(40)
            }
            .sheet(isPresented: $showAdd){
                AddDayView()
                    .preferredColorScheme(.dark)
            }
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        showAdd = true
                                    }label:{
                                        Image(systemName: "plus")
                                            .foregroundColor(Color.openGreen)
                                            .font(.headline)
                                            .padding()
                                    }
                                }
                                
                            ToolbarItem(placement: .principal) {
                                    Image(systemName: "dumbbell.fill")
                                        .font(.system(size: 30))
                                        
                                }
                            }
                           
            
        }
    }
    
    func calculateCountOfExcercises(day:Day)->Int{
        var count = 0
        
        for muscle in day.muscles{
            count += muscle.exercises.count
        }
        return count
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
