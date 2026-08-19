//
//  AppConfig.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import Foundation

/// App-wide configuration values read from `Info.plist`, so they can change per build without
/// touching code — same pattern as `Endpoint.urlBase`.
enum AppConfig {
    /// The typical number of questions a session has, from `Info.plist`'s
    /// `DEFAULT_QUESTION_COUNT`. The server ultimately decides the real count per session
    /// (`HealthCheckSessionDTO.progress.total`) — this only backs the intro screen's copy and
    /// `QuestionCoordinator`'s progress bar before that value exists yet.
    static let defaultQuestionCount = Bundle.main.infoDictionary?["DEFAULT_QUESTION_COUNT"] as? Int ?? 5
}
