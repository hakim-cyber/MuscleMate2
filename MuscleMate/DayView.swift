//
//  DayView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI
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

struct DayView: View {
    @ObservedObject var viewModel:DayView_viewModel
   
    
   
    var body: some View {
        VStack{
            if viewModel.showadding{
                if viewModel.availibleMuscles.count != 0{
                    HStack{
                        
                        Picker("", selection: $viewModel.pickedMuscle) {
                            ForEach(viewModel.availibleMuscles, id: \.self) { muscle in
                                Text(muscle.uppercased())
                                    .foregroundColor(Color.openGreen)
                            }
                        }
                        .labelsHidden()
                        .padding()
                        
                        Spacer()
                        Text("\(viewModel.pickedMuscle.uppercased())")
                            .font(.system(size: 20))
                            .padding()
                    }
                    .foregroundColor(Color.openGreen)
                    HStack{
                        Spacer()
                        Button("Add Muscle"){
                            let muscle = Muscle(muscle: viewModel.pickedMuscle.uppercased(), exercises: [ExerciseApi]())
                            withAnimation {
                                viewModel.day.muscles.append(muscle)
                                
                            }
                            self.viewModel.change()
                            
                            viewModel.newAvailible()
                            
                        }
                        Spacer()
                    }
                    .onChange(of: viewModel.availibleMuscles){newArray in
                        if !newArray.isEmpty{
                            viewModel.pickedMuscle = newArray[0]
                        }
                    }
                }else{
                    Text("all availible muscles used")
                        .font(.largeTitle)
                        .foregroundColor(Color.gray)
                }
            }
               
            
            ScrollView{
                
                
                
                VStack(alignment: .leading){
                    ForEach(Array(viewModel.day.muscles.indices),id:\.self){index in
                        var model = ExerciseView_Model(muscle: $viewModel.day.muscles[index], change: { self.viewModel.change()})
                        NavigationLink(destination:ExcerciseView(model: model)
                        .preferredColorScheme(.dark) ){
                            HStack{
                                Button(action: {
                                    viewModel.remove(index: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal,5)
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.openGreen,lineWidth:7)
                                    .shadow(color: Color.openGreen,radius: 20)
                                    .frame(width: 350,height: 130)
                              
                                
                                
                                    .overlay(
                                        VStack{
                                            
                                            HStack{
                                                Spacer()
                                                VStack{
                                                    Spacer()
                                                    Text("\(viewModel.day.muscles[index].muscle)")
                                                        .foregroundColor(.white)
                                                        .font(.system(.largeTitle,design: .serif))
                                                        .bold()
                                                    Spacer()
                                                    
                                                }
                                                Spacer()
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.white)
                                                
                                                
                                            }
                                            Spacer()
                                            Text("\(viewModel.day.muscles[index].exercises.count) Excersices")
                                                .foregroundColor(.white)
                                                .font(.system(.callout,design: .rounded))
                                        }
                                            .padding()
                                        
                                    )
                            }
                        }
                        .buttonStyle(NavigatinLinkButtonStyle())
                        .padding(5)
                        
                    }
                }
                .padding(40)
            }
        }
        .fullScreenCover(isPresented: $viewModel.ShowStartWorkout){
            StartDayWorkout(day: viewModel.day)
                .preferredColorScheme(.light)
        }
            .toolbar{
                HStack{
                    
                    Text("~\(viewModel.estimatedTimeForWorkout / 60) mins")
                        .foregroundColor(.gray)
                    Button{
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.6)){
                            viewModel.ShowStartWorkout = true
                        }
                    }label:{
                        Label("Start",systemImage: "play.circle")
                            .labelStyle(.titleAndIcon)
                            .foregroundColor(Color.openGreen)
                    }
                    .disabled(viewModel.day.muscles.isEmpty)
                  
                    
                    
                }
                .padding()
               
                Button{
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.6)) {
                        viewModel.showadding.toggle()
                    }
                   
                   
                }label:{
                
                    if viewModel.showadding == false{
                        Image(systemName: "plus.circle")
                    }else{
                        Image(systemName: "minus.circle")
                    }
                }
                .foregroundColor(Color.openGreen)
            }
            
            .onAppear(perform:viewModel.newAvailible)
        
    }
       
   
}

struct DayView_Previews: PreviewProvider {
    @State static var day = Day(id: 4, muscles: [Muscle(muscle: "Back", exercises: [ExerciseApi.defaultExercise])])
    
    static var previews: some View {
        var dayViewodel = DayView_viewModel(day: $day,change: {})
        NavigationView{
            DayView(viewModel: dayViewodel)
                .preferredColorScheme(.dark)
        }
    }
}


