//
//  Helpers.swift
//  wisnet
//
//  Created by Tan Vo on 22/09/2022.
//

import SwiftUI
import Combine

// MARK: - General

public extension ProcessInfo {
    var isRunningTests: Bool {        
        environment["XCTestConfigurationFilePath"] != nil
    }
}

public extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}

// MARK: - View Inspection helper

public final class Inspection<V> {
    public let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()
    
    public init(callbacks: [UInt : (V) -> Void] = [UInt: (V) -> Void]()) {
        self.callbacks = callbacks
    }
    
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
