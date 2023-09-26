//
//  CornerRadiusShape.swift
//  wisnet
//
//  Created by Tan Vo on 04/10/2022.
//

import SwiftUI

public struct CornerRadiusShape: Shape {
    public var radius = CGFloat.infinity
    public var corners = UIRectCorner.allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public struct CornerRadiusStyle: ViewModifier {
    public var radius: CGFloat
    public var corners: UIRectCorner

    public func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

public extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
