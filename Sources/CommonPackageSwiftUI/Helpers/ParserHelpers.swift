//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public protocol ParserCodableStrategy {
    associatedtype RawValue: Codable
    associatedtype Result: Codable

    static func decode(_ value: RawValue?) throws -> Result?
    static func encode(_ value: Result?) -> RawValue?
}

@propertyWrapper
public struct ParserValue<Strategy: ParserCodableStrategy>: Codable {
    private let value: Strategy.RawValue?
    public var wrappedValue: Strategy.Result?
    
    public init(from decoder: Decoder) throws {
        self.value = try Strategy.RawValue(from: decoder)
        self.wrappedValue = try Strategy.decode(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension KeyedDecodingContainer {
    func decode<P>(_: ParserValue<P>.Type, forKey key: Key) throws -> ParserValue<P>? {
        return try decodeIfPresent(ParserValue<P>.self, forKey: key)
    }
}

public protocol AnyCodable: Codable {
    associatedtype Value: Codable
    var value: Value? { get set }
    init(_ value: Value?)
}

public struct AnyToValueStrategy<Value: AnyCodable>: ParserCodableStrategy {
    
    public static func decode(_ value: Value?) throws -> Value.Value? {
        return value?.value
    }

    public static func encode(_ value: Value.Value?) -> Value? {
        return Value(value)
    }
}

// MARK: - Any to Int
struct IntCodable: AnyCodable {
    var value: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let val = try? container.decode(String.self) {
            value = val.asInt
        } else if let val = try? container.decode(Int.self) {
            value = val
        } else {
            value = nil
        }
    }

    init(_ value: Int?) {
        self.value = value
    }
}

typealias AutoInt = ParserValue<AnyToValueStrategy<IntCodable>>

// MARK: - Any to Bool
public struct BoolCodable: AnyCodable {
    public var value: Bool?

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let val = try? container.decode(Bool.self) {
            value = val
        } else if let val = try? container.decode(String.self) {
            value = val.asBool
        } else if let val = try? container.decode(Int.self) {
            value = val > 0
        } else {
            value = false
        }
    }

    public init(_ value: Bool?) {
        self.value = value
    }
}

//public typealias AutoBool = ParserValue<AnyToValueStrategy<BoolCodable>>

extension String {
    var asBool: Bool {
        return self == "1" || self == "true"
    }
    
    var asInt: Int? {
        return Int(self)
    }
}
