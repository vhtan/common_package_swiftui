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
    let currentPage: Int?
    let perPage: Int?
    let total: Int?
    let totalPage: Int?
    
    var canLoadMore: Bool {
        return (currentPage ?? 0) < (totalPage ?? 0)
    }
    
    var nextPage: Int? {
        guard let current = currentPage else {
            return nil
        }
        return current + 1
    }
}

public struct Response<T: Decodable>: Decodable{
    let message: String?
    let code: Int?
    let data: T?
}

public extension Response {
    var error: APIError? {
        return APIError(code: code, messageResponse: message)
    }
}
