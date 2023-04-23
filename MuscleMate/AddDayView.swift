//
//  AddDayView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct AddDayView: View {
    @Environment(\.dismiss) var dismiss
    @State var days = [Day]()
    
   @State var availibleDays = ["1","2","3","4","5","6","7"]
    
    @State private var dayOfWeek = "1"
    var body: some View {
        NavigationView{
            Form{
                Section("Day of Week"){
                    VStack{
                        HStack{
                            if availibleDays.count != 0{
                                Picker("",selection: $dayOfWeek){
                                    
                                    ForEach(availibleDays,id: \.self) { day in
                                        Text(day)
                                    }
                                    
                                }
                                .labelsHidden()
                            }else{
                                
                            }
                            Spacer()
                            Text(" Day \(dayOfWeek)")
                                .font(.largeTitle)
                        }
                    }
                    HStack{
                        Spacer()
                        Button("Add Day"){
                            let day = Day(id: Int(dayOfWeek)!, muscles: [Muscle]())
                            days.append(day)
                            let newAvailible =   availibleDays.filter{$0 != dayOfWeek}
                            availibleDays = newAvailible
                            
                        }
                        Spacer()
                    }
                    .disabled(availibleDays.count == 0)
            
                    List(days.sorted{$0.id < $1.id}){day in
                        Text(" Day \(day.id)")
                    }
                }
                .foregroundColor(Color.openGreen)
            }
            .onChange(of: availibleDays){newArray in
                if availibleDays.count != 0{
                    dayOfWeek = newArray[0]
                }else{
                    
                }
            }
            .toolbar{
                Button("Done"){
                   dismiss()
                }
            }
        }
    }
    
}

struct AddDayView_Previews: PreviewProvider {
    static var previews: some View {
        AddDayView()
            .preferredColorScheme(.dark)
    }
}
