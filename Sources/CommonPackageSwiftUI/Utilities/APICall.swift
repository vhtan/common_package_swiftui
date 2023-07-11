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

public struct AnyDecodable: Decodable {
}

public enum DataTask {
    case encodable(Encodable)
    case parameters([String: Any])
    case uploadFile(MultipartFormData)
    case downloadFile(url: URL)
}

extension DataTask {
    
    public struct MultipartFormData {
        let provider: Provider
        let name: String
        let boundary: String
        
        public init(provider: Provider, name: String) {
            self.provider = provider
            self.name = name
            self.boundary = "example.boundary.\(ProcessInfo.processInfo.globallyUniqueString)"
        }
        
        public enum Provider {
            case data(Data)
            case file(URL)
        }
    }
    
    fileprivate func queryItem(encoder: JSONEncoder) -> [URLQueryItem]? {
        switch self {
        case let .encodable(v):
            return v.asDictionary(encoder: encoder)?.map { URLQueryItem(name: $0.key, value: $0.value) }
        case let .parameters(p):
            return p.map { URLQueryItem(name: $0.key, value: $0.value) }
        default:
            return nil
        }
    }
}

private extension URLQueryItem {
    init(name: String, value: Any) {
        var string: String? = nil
        switch value {
        case let str as String:
            string = str
        case let number as NSNumber:
            string = number.stringValue
        case let bool as Bool:
            string = bool.description
        default:
            assertionFailure("Not support \(value)")
        }
        self.init(name: name, value: string)
    }
}

extension APICall {
    
    func urlRequest(baseURL: URL, encoder: JSONEncoder, headers: [String : String]) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = method.method
        
        var baseHeaders = headers
        if let apiHeaders = self.headers {
            apiHeaders.forEach { baseHeaders[$0.key] = $0.value }
        }
        request.allHTTPHeaderFields = baseHeaders
        
        if method == .get {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = dataTask?.queryItem(encoder: encoder)
            request.url = urlComponents?.url
            request.allHTTPHeaderFields?["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        } else {
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"
            do {
                switch dataTask {
                case let .encodable(v):
                    request.httpBody = try encoder.encode(AnyEncodable(v))
                    
                case let .parameters(p):
                    request.httpBody = p.toData()
                    
                case let .uploadFile(multipartFormData):
                    let boundary = multipartFormData.boundary
                    var mimeType: String!
                    var imageData: Data!
                    switch multipartFormData.provider {
                    case let .file(url):
                        let da = try Data(contentsOf: url)
                        mimeType = da.mimeType
                        imageData = da
                    case let .data(da):
                        imageData = da
                        mimeType = da.mimeType
                    }
                    request.httpBody = createData(binaryData: imageData, name: multipartFormData.name, mimeType: mimeType, boundary: boundary)
                    request.allHTTPHeaderFields?["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
                default: break
                }
            } catch {
                log.error(error.localizedDescription)
            }
        }
        
        logData(url: url.absoluteString, method: method, headers: request.allHTTPHeaderFields ?? [:], body: request.httpBody)
        
        return request
    }
    
    private func createData(binaryData: Data, name: String, mimeType: String, boundary: String) -> Data {
        var postContent = "--\(boundary)\r\n"
        let fileName = "\(UUID().uuidString).jpeg"
        postContent += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
        postContent += "Content-Type: \(mimeType)\r\n\r\n"
        
        var data = Data()
        guard let postData = postContent.data(using: .utf8) else { return data }
        data.append(postData)
        data.append(binaryData)
        
        guard let endData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else { return data }
        data.append(endData)
        
        return data
    }
    
    func customJSONEncodable<T: Encodable>(_ params: T, encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(params)
    }
    
    private func logData(url: String, method: HTTPMethod, headers: [String : String], body: Data?) {
        log.info("REQUEST: \(url) - METHOD: \(method.method) \nHEADERS: \(headers.json) \nBODY: \(body?.toDictionary?.json ?? "Empty")")
    }
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
