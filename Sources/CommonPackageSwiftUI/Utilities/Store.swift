//
//  Store.swift
//  wisnet
//
//  Created by Tan Vo on 22/09/2022.
//

import SwiftUI
import Combine

public typealias Store<State> = CurrentValueSubject<State, Never>

public extension Store {
    
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }
    
    func bulkUpdate(_ update: (inout Output) -> Void) {
        var value = self.value
        update(&value)
        self.value = value
    }
    
    func updates<Value>(for keyPath: KeyPath<Output, Value>) ->
        AnyPublisher<Value, Failure> where Value: Equatable {
            return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}

// MARK: -

public extension Binding where Value: Equatable {
    func dispatched<State>(to state: Store<State>,
                           _ keyPath: WritableKeyPath<State, Value>) -> Self {
        return onSet { state[keyPath] = $0 }
    }
}

public extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}
