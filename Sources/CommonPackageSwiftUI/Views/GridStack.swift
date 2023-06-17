//
//  GridStack.swift
//  wisnet
//
//  Created by Tan Vo on 23/04/2023.
//

import SwiftUI

public struct GridStack<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    @State private var height: CGFloat = .zero
    
    public var body: some View {
        VStack(spacing: 24) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
    
    public init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
