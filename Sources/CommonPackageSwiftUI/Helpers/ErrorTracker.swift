//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import Combine

/**
 Enables monitoring error of sequence computation.
 */
public final class ErrorTracker {
    private struct ActivityToken<Source: Publisher> {
        let source: Source
        let errorAction: (Source.Failure) -> Void
        
        func asPublisher() -> AnyPublisher<Source.Output, Never> {
            source.handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    errorAction(error)
                }
            })
            .catch { _ in Empty(completeImmediately: true) }
            .eraseToAnyPublisher()
        }
    }
    
    @Published
    private var relay: Error?
    private let lock = NSRecursiveLock()
    
    public var error: AnyPublisher<Error, Never> {
        $relay.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    public init() {}
    
    func trackErrorOfPublisher<Source: Publisher>(source: Source) -> AnyPublisher<Source.Output, Never> {
        return ActivityToken(source: source) { error in
            self.lock.lock()
            self.relay = error
            self.lock.unlock()
        }.asPublisher()
    }
}

extension Publisher {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Self.Output, Never> {
        errorTracker.trackErrorOfPublisher(source: self)
    }
}
