//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import Combine

public final class ActivityIndicator {
    @Published private var count = 0
    private let lock = NSRecursiveLock()
    
    public init() {}
    
    public var loading: AnyPublisher<Bool, Never> {
        $count.print("loading")
            .map({$0 > 0})
            .print("loading")
            .eraseToAnyPublisher()
    }
    
    func trackActivity<T: Publisher>(_ source: T) -> AnyPublisher<T.Output, T.Failure> {
        return source
            .handleEvents(receiveCompletion: { _ in
                self.decrement()
            }, receiveCancel: {
                self.decrement()
            }, receiveRequest: { [weak self] _ in
                self?.increment()
            })
            .eraseToAnyPublisher()
    }
    
    private func increment() {
        lock.lock()
        defer { lock.unlock() }
        
        count += 1
    }
    
    private func decrement() {
        lock.lock()
        defer { lock.unlock() }
        
        count -= 1
    }
}

public extension Publisher {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> AnyPublisher<Self.Output, Self.Failure> {
        activityIndicator.trackActivity(self)
    }
}
