//
//  FitToAspectRatio.swift
//  wisnet
//
//  Created by Tan Vo on 28/09/2022.
//

import SwiftUI

struct FitToAspectRatio: ViewModifier {
    
    private let aspectRatio: CGFloat
    
    init(_ aspectRatio: CGFloat) {
        self.aspectRatio = aspectRatio
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.clear))
                .aspectRatio(aspectRatio, contentMode: .fit)
            content
                .scaledToFill()
                .layoutPriority(-1)
        }
        .clipped()
    }
}

// Image extension that composes with the `.resizable()` modifier
extension Image {
    public func fitToAspectRatio(_ aspectRatio: CGFloat) -> some View {
        self.resizable().modifier(FitToAspectRatio(aspectRatio))
    }
}
