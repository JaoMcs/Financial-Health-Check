//
//  Endpoint.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// The pieces used to build every request URL. Only `urlBase` varies by environment
/// (debug/staging/prod), read from Info.plist; the path segments below never change at
/// runtime, so they're plain constants — each repository method concatenates them in the
/// order its own path needs, since the session id sits in a different position for each one.
/// `sessions`/`submission` carry their own leading `/`, so concatenation never needs to
/// insert one.
///
/// Usage: `Endpoint.urlBase + Endpoint.sessions + "/\(sessionId)"` (start/resume), or
/// `Endpoint.urlBase + Endpoint.sessions + "/\(sessionId)" + Endpoint.submission` (submit).
enum Endpoint {
    static let urlBase = Bundle.main.infoDictionary?["API_BASE_URL"] as? String ?? ""
    static let sessions = "/health-check/v1/sessions"
    static let submission = "/submission"
}
