//
//  Endpoint.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// The pieces used to build every request URL. Only `urlBase` varies by environment, read
/// from Info.plist; the path segments below are fixed constants.
enum Endpoint {
    static let urlBase = Bundle.main.infoDictionary?["API_BASE_URL"] as? String ?? ""
    static let sessions = "/health-check/v1/sessions"
    static let submission = "/submission"
}
