//
//  Response.swift
//  wisnet
//
//  Created by Tan Vo on 09/10/2022.
//

import Foundation

public enum StatusCode: Int {
    case success = 200
    case authError = 400
    case emptyAccessKey = 3005
    case wrongAccessKey = 3006
}

public struct Pagination: Decodable {
    public let currentPage: Int?
    public let perPage: Int?
    public let total: Int?
    public let totalPage: Int?
    
    public var canLoadMore: Bool {
        return (currentPage ?? 0) < (totalPage ?? 0)
    }
    
    public var nextPage: Int? {
        guard let current = currentPage else {
            return nil
        }
        return current + 1
    }
}

public struct Response<T: Decodable>: Decodable{
    public let message: String?
    public let code: Int?
    public let data: T?
}

public extension Response {
    var error: APIError? {
        return APIError(code: code, messageResponse: message)
    }
}
