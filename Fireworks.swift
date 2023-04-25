//
//  Fireworks.swift
//  MuscleMate
//
//  Created by aplle on 4/26/23.
//

import Foundation
import SwiftUI

struct Fireworks: View {
    @State private var colors = [Color.red, Color.yellow, Color.orange, Color.pink, Color.purple, Color.green, Color.blue]

    var body: some View {
        ForEach(0..<30) { _ in
            Circle()
                .fill(colors.randomElement()!)
                .frame(width: 10, height: 10)
                .opacity(0)
                .animation(Animation.linear(duration: 2.0).delay(Double.random(in: 0...1)))
                .overlay(
                    Circle()
                        .stroke(colors.randomElement()!, lineWidth: 2)
                        .frame(width: 30, height: 30)
                        .opacity(0)
                        .animation(Animation.linear(duration: 2.0).delay(Double.random(in: 0...1)))
                )
                .onAppear {
                    self.colors.shuffle()
                }
        }
    }
}
