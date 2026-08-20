//
//  SplashDestination.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// Where `AppCoordinator` routes to once it's resolved the current session state.
enum SplashDestination {
    /// No persisted session yet — the flow's very first screen.
    case start
    /// A persisted session, still in progress, resuming on this question.
    case question(HealthCheckSessionDTO)
    /// A persisted session that already reached its result.
    case result(ResultDTO)
}
