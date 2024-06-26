//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public enum BuildEnvironment {
    case debugDev
    case debugStag
    case debugPro
    case releaseStag
    case releasePro
    case releaseDev
    
    public var isDebug: Bool {
        return self == .debugDev || self == .debugStag || self == .debugPro
    }
    
    public init(value: String) {
        switch value {
        case "debug_stag":      self = .debugStag
        case "debug_pro":       self = .debugPro
        case "release_stag":    self = .releaseStag
        case "release_pro":     self = .releasePro
        case "release_dev":     self = .releaseDev
        default:    self = .debugDev
        }
    }
}

public struct BuildConfiguration {
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    static func value(for key: String) throws -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            throw Error.invalidValue
        }
        
        return value
    }
    
    public var environment: BuildEnvironment {
        do {
            return try BuildEnvironment(value: BuildConfiguration.value(for: "ENVIRONMENT"))
        } catch { }
        
        return .debugDev
    }
    
    public func baseAPIURL(apiConfigs: [APIService.APIConfig]) -> URL {
        let http = apiConfigs.first(where: {
            if case .hasSSL = $0 {
                return true
            }
            return false
        }) != nil ? "https" : "http"
        let pathComponent = apiConfigs.compactMap({
            if case let .path(path) = $0 {
                return path
            }
            return nil
        }).first.map { $0 }
        do {
            let path = try BuildConfiguration.value(for: apiKey)
            if let pathComponent = pathComponent {
                return URL(string: "\(http)://\(path)")!.appendingPathComponent(pathComponent, conformingTo: .url)
            } else {
                return URL(string: "\(http)://\(path)")!
            }
        } catch {
            assertionFailure("Missing \(apiKey) in Info.plist")
            return URL(string: "")!
        }
    }
    
    public var fileAPIURL: URL {
        do {
            let path = try BuildConfiguration.value(for: "FILE_API_URL")
            if environment.isDebug {
                return URL(string: "http://\(path)")!
            } else {
                return URL(string: "http://\(path)")!
            }
        } catch {
            assertionFailure("Missing FILE_API_URL in Info.plist")
            return URL(string: "")!
        }
    }
}
