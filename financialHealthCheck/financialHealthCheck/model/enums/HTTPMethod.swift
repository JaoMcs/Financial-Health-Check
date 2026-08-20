//
//  HTTPMethod.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// The HTTP method a `NetworkManager` request is sent with.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
