//
//  ExcerciseView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct ExcerciseView: View {
    @ObservedObject var model:ExerciseView_Model
    @State private var screen = UIScreen.main.bounds
    var body: some View {
        VStack{
            if model.showadding{
                VStack{
                    HStack{
                        Spacer()
                        Picker("Select an exercise", selection: $model.pickedExcerciseTry) {
                            ForEach(model.exercisesForThisMuscle.indices, id: \.self) { index in
                                Text(model.exercisesForThisMuscle[index].name.uppercased())
                            }
                        }
                        .pickerStyle(.menu)
                       
               
                        Spacer()
                        
                    }
                    .padding()
                     
                    HStack{
                        Picker("Sets",selection: $model.setsCount){
                            ForEach(Array(2...5),id: \.self) { setCount in
                                Text("\(setCount) sets")
                                    .foregroundColor(Color.openGreen)
                            }
                            
                        }
                        .foregroundColor(Color.openGreen)
                        Text("x")
                            .foregroundColor(Color.openGreen)
                        Picker("Repeats",selection: $model.repeatsCount){
                            ForEach(Array(2...15),id: \.self) { setCount in
                                Text("\(setCount) repeats")
                                    .foregroundColor(Color.openGreen)
                            }
                            
                        }
                        .foregroundColor(Color.openGreen)
              
                        
                    }
                }
                .foregroundColor(Color.openGreen)
                .padding(5)
                HStack{
                    Spacer()
                    Button("Add Excercise"){
                        var excercise = model.exercisesForThisMuscle[model.pickedExcerciseTry]
                        excercise.sets = model.setsCount
                        excercise.repeatCount = model.repeatsCount
                        withAnimation {
                   
                            model.muscle.exercises.append(excercise)
                            
                        }
                       
                        model.change()
                    }
                    .foregroundColor(Color.openGreen)
                    Spacer()
                }
                .padding()
                
            }
            
            ScrollView{
                ForEach(model.muscle.exercises){excersise in
                    HStack{
                        let index = model.muscle.exercises.firstIndex(of:excersise)
                        VStack{
                            Image(systemName: "\((index ?? 0) + 1).circle")
                                .font(.headline)
                                .foregroundColor(Color.openGreen)
                                .padding(4)
                            
                            Button(action: {
                                model.remove(index: index!)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.vertical,9)
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.openGreen,lineWidth:7)
                          
                            .overlay(
                                HStack{
                                    Text("\(excersise.name.uppercased())")
                                        .font(.system(.headline,design: .serif))
                                        .padding()
                                        .bold()
                                 
                                    Spacer()
                                    
                                    Text("\(excersise.sets!) x \(excersise.repeatCount!)")
                                        .padding(25)
                                        .font(.system(.largeTitle,design: .rounded))
                                        .foregroundColor(.gray)
                 
                                    
                                }
                            )
                    }
                    .frame(width: screen.width / 1.1,height: screen.height / 7.5)
                    .padding(5)
                   
                }
                .padding(40)
            }
            .navigationTitle("\(model.muscle.muscle)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                
                Button{
                    withAnimation {
                        model.showadding.toggle()
                    }
                    
                    
                }label:{
                    
                    if model.showadding == false{
                        Image(systemName: "plus.circle")
                    }else{
                        Image(systemName: "minus.circle")
                    }
                }
                .foregroundColor(Color.openGreen)
                
            }
        }
        .onAppear{
            model.loadExercises()
        }
        
    }
   
   
}

struct ExcerciseView_Previews: PreviewProvider {
    @State  static var muscle = Muscle(muscle: "Chest", exercises: [ExerciseApi.defaultExercise])
    static var previews: some View {
        let model = ExerciseView_Model(muscle:$muscle, change: {})
        NavigationView{
            ExcerciseView(model: model)
                .preferredColorScheme(.dark)
        }
    }
}
