//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation

public enum WEnvironment {
    case debugDev
    case debugStag
    case debugPro
    case releaseStag
    case releasePro
    case releaseDev
    
    public var isDebug: Bool {
        return self == .debugDev || self == .debugStag || self == .debugPro
    }
    
    init(value: String) {
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

public struct WConfiguration {
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    public init() { }

    static func value(for key: String) throws -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            throw Error.invalidValue
        }
        
        return value
    }
    
    public var environment: WEnvironment {
        do {
            return try WEnvironment(value: WConfiguration.value(for: "ENVIRONMENT"))
        } catch { }
        
        return .debugDev
    }
    
    public var baseAPIURL: URL {
        do {
            let path = try WConfiguration.value(for: "BASE_API_URL")
            if environment.isDebug {
                return URL(string: "http://\(path)")!.appendingPathComponent("v1")
            } else {
                return URL(string: "http://\(path)")!.appendingPathComponent("v1")
            }
        } catch {
            assertionFailure("Missing BASE_API_URL in Info.plist")
            return URL(string: "")!
        }
    }
    
    public var fileAPIURL: URL {
        do {
            let path = try WConfiguration.value(for: "FILE_API_URL")
            if environment.isDebug {
                return URL(string: "http://\(path)")!.appendingPathComponent("v1")
            } else {
                return URL(string: "http://\(path)")!.appendingPathComponent("v1")
            }
        } catch {
            assertionFailure("Missing FILE_API_URL in Info.plist")
            return URL(string: "")!
        }
    }
}
