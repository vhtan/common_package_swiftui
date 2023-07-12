//
//  APIError.swift
//  wisnet
//
//  Created by Tan Vo on 09/10/2022.
//

public struct APIError: Error {
    public var code: Int?
    public var messageResponse: String?

    init(code: Int? = nil, messageResponse: String? = nil) {
        self.code = code
        self.messageResponse = messageResponse
    }

    public static func defaultError() -> APIError {
        return APIError(code: nil, messageResponse: nil)
    }
}
