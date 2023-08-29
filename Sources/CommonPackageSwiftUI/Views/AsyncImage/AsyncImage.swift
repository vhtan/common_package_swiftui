//
//  AsyncImage.swift
//  
//
//  Created by Tan Vo on 29/08/2023.
//

import SwiftUI

public struct AsyncImage<Placeholder, V>: View where Placeholder: View, V: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> V
    
    public init(url: URL, cache: ImageCache? = nil,
                placeholder: Placeholder? = nil,
                configuration: @escaping (Image) -> V = { $0 }) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    public var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}
