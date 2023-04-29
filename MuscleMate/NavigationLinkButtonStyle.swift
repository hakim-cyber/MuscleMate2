//
//  NavigationLinkButtonStyle.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//

import Foundation
import SwiftUI


struct NavigatinLinkButtonStyle:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.spring(), value:0.8)
        }
}
