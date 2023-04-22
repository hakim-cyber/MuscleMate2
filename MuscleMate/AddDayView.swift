//
//  AddDayView.swift
//  MuscleMate
//
//  Created by aplle on 4/23/23.
//

import SwiftUI

struct AddDayView: View {
    @State var days = [Day]()
    var body: some View {
        NavigationView{
            Form{
                
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
