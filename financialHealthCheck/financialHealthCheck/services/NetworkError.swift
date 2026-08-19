//
//  NetworkError.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// Every error `NetworkManager` can throw. The named cases mirror the API's own error
/// codes — `NetworkManager` maps a non-2xx response's `(statusCode, APIErrorDTO.code)` pair
/// to one of them; anything it doesn't recognize becomes `.unrecognizedServerError` instead
/// of failing silently.
enum NetworkError: Error {
    /// 400 `INVALID_SESSION_ID`.
    case invalidSessionId
    /// 400 `INVALID_QUESTION`.
    case invalidQuestion
    /// 400 `QUESTION_NOT_FOUND`.
    case questionNotFound
    /// 404 `SESSION_NOT_FOUND`.
    case sessionNotFound
    /// 409 `SESSION_ALREADY_COMPLETED`.
    case sessionAlreadyCompleted
    /// 422 `VALIDATION_ERROR`.
    case validationError(field: String?, message: String?)
    /// 429 `RATE_LIMITED`.
    case rateLimited
    /// 405 `METHOD_NOT_ALLOWED`.
    case methodNotAllowed
    /// Any other `(statusCode, code)` pair.
    case unrecognizedServerError(statusCode: Int, code: String?, message: String?)
    /// The response wasn't an `HTTPURLResponse` at all.
    case invalidResponse
    /// `JSONDecoder` failed on an otherwise-successful (2xx) response.
    case decodingFailed(Error)
    /// `URLSession` itself failed — no connectivity, timeout, a malformed URL, etc.
    case transport(Error)
}

extension NetworkError: Equatable {
    /// Compares by case. `.transport`/`.decodingFailed` compare equal to each other
    /// regardless of the wrapped `Error`'s own value, since `Error` itself isn't `Equatable`.
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidSessionId, .invalidSessionId),
             (.invalidQuestion, .invalidQuestion),
             (.questionNotFound, .questionNotFound),
             (.sessionNotFound, .sessionNotFound),
             (.sessionAlreadyCompleted, .sessionAlreadyCompleted),
             (.rateLimited, .rateLimited),
             (.methodNotAllowed, .methodNotAllowed),
             (.invalidResponse, .invalidResponse),
             (.transport, .transport),
             (.decodingFailed, .decodingFailed):
            return true
        case let (.validationError(lField, lMessage), .validationError(rField, rMessage)):
            return lField == rField && lMessage == rMessage
        case let (.unrecognizedServerError(lStatus, lCode, lMessage), .unrecognizedServerError(rStatus, rCode, rMessage)):
            return lStatus == rStatus && lCode == rCode && lMessage == rMessage
        default:
            return false
        }
    }
}
