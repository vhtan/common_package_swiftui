//
//  CancelBag.swift
//  wisnet
//
//  Created by Tan Vo on 22/09/2022.
//

import Combine

public final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    public init() { }
    
    public func cancel() {
        subscriptions.removeAll()
    }
}

public extension AnyCancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
