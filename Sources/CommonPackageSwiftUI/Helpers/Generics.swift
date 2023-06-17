//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public struct Stack<Element> {
    private var stack = [Element]()
    
    public mutating func push(_ data: Element) {
        stack.append(data)
    }
    
    public mutating func pop() -> Element? {
        return stack.popLast()
    }
}

public struct Queue<Element> {
    private var queue = [Element]()
    
    public init() {
    }
    
    public mutating func enqueue(_ data: Element) {
        queue.append(data)
    }
    
    public mutating func dequeue() -> Element? {
        if queue.first != nil {
            return queue.removeFirst()
        } else {
            return nil
        }
    }
}
