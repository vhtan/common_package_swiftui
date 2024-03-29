//
//  File.swift
//  
//
//  Created by Tan Vo on 17/06/2023.
//

import Foundation

public protocol SessionRepository {
    var access: Access? { get }
    var session: Session? { get }
    var headers: [String: String] { get }
    var isLoggedIn: Bool { get }
    func clean()
    func saveSession(session: Session)
    func saveAccess(access: Access)
}

public struct Access {
    public let deviceId: String?
    public let accessKey: String?
    
    public init(deviceId: String?, accessKey: String?) {
        self.deviceId = deviceId
        self.accessKey = accessKey
    }
}

public struct Session {
    public let token: String?
    public let userId: Int?
    
    public init(token: String?, userId: Int?) {
        self.token = token
        self.userId = userId
    }
}
