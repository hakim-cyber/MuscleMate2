//
//  AddDayView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct AddDayView: View {
    @State var days = [Day]()
    let availibleDays = ["1","2","3","4","5","6","7"]
    @State private var dayOfWeek
    var body: some View {
        NavigationView{
            Form{
                Section("Day of Week"){
                    Picker("",selection: $dayOfWeek){
                        
                    }
                }
                .foregroundColor(Color.openGreen)
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
