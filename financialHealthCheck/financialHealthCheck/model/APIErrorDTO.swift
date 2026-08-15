//
//  APIErrorDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// The body of a non-2xx API response.
///
/// Dependencies: `DTO`.
///
/// Usage: decoded by `NetworkManager` whenever a response's status code isn't 2xx, then
/// mapped (together with that status code) to a `NetworkError` case.
struct APIErrorDTO: DTO {
    /// A machine-readable error code, e.g. `"INVALID_SESSION_ID"`.
    var code: String?
    /// A human-readable description of the error.
    var message: String?
    /// The offending field's name. Only expected alongside `code == "VALIDATION_ERROR"`.
    var field: String?
}
