//
//  APICall.swift
//  wisnet
//
//  Created by Tan Vo on 22/09/2022.
//

import Foundation

public protocol APICall {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var dataTask: DataTask? { get }
}

public struct AnyEncodable: Encodable {

    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

public enum DataTask {
    case encodable(Encodable)
    case parameters([String: Any])
    case uploadFile(url: URL, name: String)
    case downloadFile(url: URL)
    
    fileprivate func body(encoder: JSONEncoder) throws -> Data? {
        switch self {
        case let .encodable(v):
            return try encoder.encode(AnyEncodable(v))
        case let .parameters(p):
            return p.toData()
        default:
            return nil
        }
    }
}

extension APICall {
    func urlRequest(baseURL: URL, encoder: JSONEncoder, headers: [String : String]) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.method
        
        var baseHeaders = headers
        if let apiHeaders = self.headers {
            apiHeaders.forEach { baseHeaders[$0.key] = $0.value }
        }
        request.allHTTPHeaderFields = baseHeaders
        
        request.httpBody = try dataTask?.body(encoder: encoder)
        
        logData(url: url.absoluteString, method: method, headers: baseHeaders, body: request.httpBody)
        
        return request
    }
    
    func customJSONEncodable<T: Encodable>(_ params: T, encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(params)
    }
    
    private func logData(url: String, method: HTTPMethod, headers: [String : String], body: Data?) {
        log.info("\n==> REQUEST: \(url) \n==> METHOD: \(method.method) \n==> HEADERS: \(headers) \n==> BODY: \(body?.toDictionary?.json ?? "")\n<========")
    }
}

public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>

public extension HTTPCodes {
    static let success = 200 ..< 300
}

public enum HTTPMethod {
    case connect, delete, get, head, options, patch, post, put, trace
    
    fileprivate var method: String {
        switch self {
        case .connect: return "CONNECT"
        case .delete: return "DELETE"
        case .get: return "GET"
        case .head: return "HEAD"
        case .options: return "OPTIONS"
        case .patch: return "PATCH"
        case .post: return "POST"
        case .put: return "PUT"
        case .trace: return "TRACE"
        }
    }
}

public extension Dictionary {
    func toData() -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            return nil
        }
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
