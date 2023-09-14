//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import Combine

open class APIService: NSObject {
    lazy private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    public var baseURL: URL!
    public var decoder: JSONDecoder!
    public var encoder: JSONEncoder!
    public var sessionTask: SessionTask!
    public var bgQueue: DispatchQueue = .init(label: "bg_parse_queue")
    public var headers: [String : String] {
        return sessionRepository.headers
    }
    public var sessionRepository: SessionRepository
    
    public required init(sessionRepository: SessionRepository, configuration: BuildConfiguration,
                         encoder: JSONEncoder, decoder: JSONDecoder, sessionTask: SessionTask,
                         configs: [APIConfig]? = nil) {
        self.sessionRepository = sessionRepository
        self.sessionTask = sessionTask
        self.decoder = decoder
        self.encoder = encoder
        self.baseURL = configuration.baseAPIURL(apiConfigs: configs ?? [])
    }
    
    public enum APIConfig {
        case hasSSL
        case path(String)
    }
}

extension APIService: URLSessionDelegate {
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.serverTrust == nil {
            completionHandler(.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        }
    }
}

extension APIService {
    
    public func call<Value: Decodable>(endpoint: APICall) -> AnyPublisher<Response<Value>, Error> {
        let request = endpoint.urlRequest(baseURL: baseURL, encoder: encoder, headers: headers)
        if log.outputLevel == .debug {
            print(request.cURL(pretty: true))
        }
        return session
            .dataTaskPublisher(for: request)
            .requestJSON(decoder: decoder)
    }
}

// MARK: - Helpers
private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value: Decodable>(decoder: JSONDecoder) -> AnyPublisher<Response<Value>, Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            self.logData(url: $0.response.url?.absoluteString ?? "Nil", data: $0.data)
            return $0.data
        }
        .extractUnderlyingError()
        .decode(type: Response<Value>.self, decoder: decoder)
        .logError()
        .tryMap { response in
            guard let errorCode = response.code else {
                throw APIError.defaultError()
            }
            if errorCode != 200 {
                throw response.error ?? APIError.defaultError()
            }
            
            return response
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func logData(url: String, data: Data?) {
        guard let data = data,
              let json = data.toDictionary?.json else {
            return
        }
        log.info("RESPONSE: \(url) ==>\nBODY: \(json)")
    }
}

public class SessionTask {
    
    private var tasks: [URLSessionTask]
    
    public init() {
        tasks = [URLSessionTask]()
    }
    
    public func add(task: URLSessionTask) {
        self.tasks.append(task)
    }
    
    public func remove(task: URLSessionTask) {
        guard let index = tasks.enumerated().first(where: { $0.element.taskIdentifier == task.taskIdentifier })?.offset else {
            return
        }
        self.tasks.remove(at: index)
    }
}


extension URLRequest {
    public func cURL(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
