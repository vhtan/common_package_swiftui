//
//  File.swift
//  
//
//  Created by Tan Vo on 13/08/2023.
//

import Combine
import SwiftUI

public struct ImageView {
    @ObservedObject private var imageLoader: ImageLoader
    @State var image:UIImage = UIImage()
    
    public init(url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}

private class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, self != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
        }
        task.resume()
    }
}
