//
//  APIError.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation
/// Contains errors that can be thrown by `APIClient`.
///
/// - requestBuildError: The request could not be built.
/// - connectionError: There was a connection error.
/// - responseValidationError: Received response is not valid.
/// - responseParseError: Received response could not be parsed.

public enum APIClientError: Error {
    case requestBuildError
    case connectionError
    case wrongStatusCode(Int)
    case responseValidationError
    case responseParseError(Error)
}

struct APIError: Error {
    let statusCode: Int?
    let underlyingError: Error
    let responseError: ResponseError? // Detailed error we get from api, containing localized error to show to user
}

struct ResponseError: Codable {
    let errorId: String
    let debugMessage: String
    let localizedMessage: String
    let status: Int
    let timeStamp: String
    let path: String
    let requestId: String
    let requestMethod: String
    let errors: [FieldError]

    enum CodingKeys: String, CodingKey {
        case errorId = "error"
        case debugMessage = "message"
        case localizedMessage, status, timeStamp, path
        case requestId
        case requestMethod, errors
    }
}

struct FieldError: Codable {
    let field: String
    let errorCode: String
    let message: String
}
