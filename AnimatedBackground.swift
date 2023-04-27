//
//  AnimatedBackground.swift
//  MuscleMate
//
//  Created by aplle on 4/26/23.
//

import SwiftUI

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 200, height: 100)
                .mask(
                    Text("Hello, World!")
                    
                    
                )

                
        }

    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground()
    }
}
