//
//  PublisherExtension.swift
//  wisnet
//
//  Created by Tan Vo on 09/10/2022.
//

import Foundation
import Combine

public extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

public extension Publisher {
    func logError() -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                log.error(error)
            }
        })
    }
}
