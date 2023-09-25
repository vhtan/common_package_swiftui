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
public class ErrorTracker {
    private let subject = PassthroughSubject<Error, Never>()
    
    public var error: AnyPublisher<Error, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func track(_ error: Error) {
        subject.send(error)
    }
}

public extension Publisher {
    func trackError<Tracker: ErrorTracker>(_ tracker: Tracker) -> AnyPublisher<Self.Output, Never> where Self.Failure == Error {
        self.catch { error -> Empty<Self.Output, Never> in
            tracker.track(error)
            return Empty()
        }
        .eraseToAnyPublisher()
    }
}
