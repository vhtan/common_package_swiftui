//
//  APIError.swift
//  wisnet
//
//  Created by Tan Vo on 09/10/2022.
//

public struct APIError: Error {
    public var code: Int?
    public var messageResponse: String?
    public var message: String?
    
    init(code: Int? = nil, messageResponse: String? = nil, message: String? = nil) {
        self.code = code
        self.messageResponse = messageResponse
        self.message = message
    }
    
    public static func defaultError() -> APIError {
        return APIError(code: nil, messageResponse: nil)
    }
}
