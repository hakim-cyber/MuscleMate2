//
//  ContentView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI
import UserNotifications
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel = ContentView_ViewModel()
    

    
    
    let DailyTimer = Timer.publish(every: 86400, on: .current, in: .common).autoconnect()
    let weeklyTimer = Timer.publish(every: 86400 * 7, on: .current, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(Array(viewModel.daysOfWeek.indices).sorted{viewModel.daysOfWeek[$0].id < viewModel.daysOfWeek[$1].id  } , id:\.self) { index in
                        var dayViewModel = DayView_viewModel(day: $viewModel.daysOfWeek[index],change: {
                            viewModel.save()
                            viewModel.load()
                            
                        })

                        NavigationLink(destination:DayView(viewModel: dayViewModel).preferredColorScheme(.dark) ){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(viewModel.checkToday(day: viewModel.CheckWeekDay(day: viewModel.daysOfWeek[index])) ? Color.underlinedGreen : Color.openGreen)
                                .frame(width: 380,height: 150)
                                .overlay(
                                    VStack{
                                        Button(action: {
                                            viewModel.remove(index)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                            
                                            
                                        }
                                        .padding()
                                        .background(viewModel.checkToday(day: viewModel.CheckWeekDay(day: viewModel.daysOfWeek[index])) ? Color.underlinedGreen : Color.openGreen)
                                        .cornerRadius(15)
                                        
                                       
                                        if viewModel.checkIsMade(day: viewModel.daysOfWeek[index]){
                                            Image(systemName: "checkmark.seal.fill")
                                                .padding(.vertical,10)
                                                .foregroundColor(.blue)
                                        }else{
                                            Image(systemName: "xmark.seal.fill")
                                                .foregroundColor(.red)
                                                .padding(.vertical,10)
                                        }
                                    }
                                                                    
                                                                        , alignment: .leading)
                              
                                .overlay(
                                    VStack{
                                        
                                        HStack{
                                            Spacer()
                                            Text("\(viewModel.CheckWeekDay(day:viewModel.daysOfWeek[index]))")
                                                .foregroundColor(.black)
                                                .font(.system(.largeTitle,design: .serif))
                                                .bold()
                                          Spacer()
                                            VStack{
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.black)
                                                    .padding(.vertical,8)
                                               
                                            }
                                        
                                        }
                                 Spacer()
                                        Text("\(viewModel.calculateCountOfExcercises(day:viewModel.daysOfWeek[index])) Excersices")
                                            .foregroundColor(.black.opacity(0.9))
                                            
                                    }
                                        .padding()
                                )
                                
                                                                    
                        }
                        .buttonStyle(NavigatinLinkButtonStyle())
                        
                    }
                    .onReceive(DailyTimer){_ in
                        viewModel.defineTodayString()
                    }
                    .onReceive(weeklyTimer){_ in
                        let EmptyMadeArray = [Day]()
                        let saveKeyMade = "Made"
                        
                        if let encoded = try? JSONEncoder().encode(EmptyMadeArray){
                            UserDefaults.standard.setValue(encoded, forKey: saveKeyMade)
                        }
                        viewModel.loadMadeDays()
                    }
                    .onAppear{
                        viewModel.defineTodayString()
                    }
                   
                   
                }
                .padding(40)
                
            }
            .sheet(isPresented: $viewModel.showAdd,onDismiss: viewModel.load){
                AddDayView()
                    .preferredColorScheme(.dark)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                        Button {
                            withAnimation {
                                viewModel.showAdd = true
                            }
                            
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
            .onAppear{
                viewModel.load()
                viewModel.loadMadeDays()
                viewModel.loadAllExcercises()
            }
            .preferredColorScheme(.dark)
                           
            
        }
    }
    
    
  
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
