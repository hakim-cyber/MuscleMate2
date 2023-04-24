//
//  ExcerciseView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct ExcerciseView: View {
    @Binding var muscle:Muscle
    var change: (() -> Void)? = nil
    
    @State var showadding =  false
    @State var pickedExcercise = ""
    @State var setsCount = 1
    @State var repeatsCount = 1
    var body: some View {
        VStack{
            if showadding{
                VStack{
                    HStack{
                        Spacer()
                        TextField("Excercise", text: $pickedExcercise)
                            .foregroundColor(Color.openGreen)
                        Spacer()
                    }
                     
                    HStack{
                        Picker("Sets",selection: $setsCount){
                            ForEach(Array(2...5),id: \.self) { setCount in
                                Text("\(setCount) sets")
                                    .foregroundColor(Color.openGreen)
                            }
                            
                        }
                        .foregroundColor(Color.openGreen)
                        Text("x")
                            .foregroundColor(Color.openGreen)
                        Picker("Repeats",selection: $repeatsCount){
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
                      let excercise = Exercise(name: pickedExcercise, repeatsCount: repeatsCount, setsCount: setsCount)
                        withAnimation {
                            muscle.exercises.append(excercise)
                        }
                       
                        self.change?()
                    }
                    .foregroundColor(Color.openGreen)
                    Spacer()
                }
                .padding()
                .disabled(self.pickedExcercise == "")
            }
            
            ScrollView{
                ForEach(muscle.exercises){excersise in
                    HStack{
                        let index = muscle.exercises.firstIndex(of:excersise)
                        VStack{
                            Image(systemName: "\((index ?? 0) + 1).circle")
                                .font(.headline)
                                .foregroundColor(Color.openGreen)
                                .padding(4)
                            
                            Button(action: {
                                remove(index: index!)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.vertical,9)
                            }
                        }
                        
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
                    .padding(5)
                }
                .padding(40)
            }
            .navigationTitle("\(muscle.muscle)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                
                Button{
                    withAnimation {
                        showadding.toggle()
                    }
                    
                    
                }label:{
                    
                    if showadding == false{
                        Image(systemName: "plus.circle")
                    }else{
                        Image(systemName: "minus.circle")
                    }
                }
                .foregroundColor(Color.openGreen)
                
            }
        }
        
    }
    func remove(index:Int){
        muscle.exercises.remove(at: index)
        change?()
    }
}

struct ExcerciseView_Previews: PreviewProvider {
    @State  static var muscle = Muscle(muscle: "Chest", exercises: [Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4),Exercise(name: "bench Press", repeatsCount: 14, setsCount: 4)])
    static var previews: some View {
        NavigationView{
            ExcerciseView(muscle:$muscle)
                .preferredColorScheme(.dark)
        }
    }
}
