//
//  ContentView.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI


struct ContentView: View {
    @State var  daysOfWeek = [Day]()
    
    @State var showAdd = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(Array(daysOfWeek.indices) , id:\.self) { index in
                        
                        NavigationLink(destination:DayView(day: $daysOfWeek[index]){
                            save()
                            load()
                        }.preferredColorScheme(.dark) ){
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.openGreen)
                                .frame(width: 350,height: 150)
                                .overlay(
                                                                
                                                                        Button(action: {
                                                                            remove(index)
                                                                        }) {
                                                                            Image(systemName: "trash")
                                                                                .foregroundColor(.red)
                                                                        }
                                                                        
                                                                     
                                                                       
                                                                    
                                                                    .padding()
                                                                    .background(Color.openGreen)
                                                                    .cornerRadius(15)
                                                                    
                                                                        , alignment: .leading)
                                .overlay(
                                    VStack{
                                        
                                        HStack{
                                            Spacer()
                                            Text("Day \(daysOfWeek[index].id)")
                                                .foregroundColor(.black)
                                                .font(.largeTitle)
                                                .bold()
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                                .foregroundColor(.black)
                                              
                                        
                                        }
                                 Spacer()
                                        Text("\(calculateCountOfExcercises(day:daysOfWeek[index])) Excersices")
                                            .foregroundColor(.black.opacity(0.9))
                                            
                                    }
                                        .padding()
                                )
                                
                                                                    
                        }
                        
                    }
                   
                }
                .padding(40)
            }
            .sheet(isPresented: $showAdd,onDismiss: load){
                AddDayView()
                    .preferredColorScheme(.dark)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   
                        Button {
                            withAnimation {
                                showAdd = true
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
            .onAppear(perform: load)
                           
            
        }
    }
    
    func calculateCountOfExcercises(day:Day)->Int{
        var count = 0
        
        for muscle in day.muscles{
            count += muscle.exercises.count
        }
        return count
        
    }
    func load(){
        if let data = UserDefaults.standard.data(forKey: Day.saveKey){
            if let decoded = try? JSONDecoder().decode([Day].self, from: data){
                daysOfWeek = decoded
                
                  
                
            }
        }
    }
    func save(){
        if let encoded = try? JSONEncoder().encode(daysOfWeek){
            UserDefaults.standard.set(encoded, forKey: Day.saveKey)
        }
    }
    func remove(_ index: Int){
            daysOfWeek.remove(at: index)
            save()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
