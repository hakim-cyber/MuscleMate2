//
//  Colors.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import Foundation
import SwiftUI


extension Color{
    static let openGreen = Color(UIColor(red: 0.788, green: 0.949, blue: 0.302, alpha: 1))
    static let underlinedGreen = Color(UIColor(red: 0.631, green: 0.847, blue: 0.918, alpha: 1))
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
