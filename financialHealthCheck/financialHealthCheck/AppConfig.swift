//
//  AppConfig.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import Foundation

/// App-wide configuration values read from `Info.plist`.
enum AppConfig {
    /// The typical number of questions a session has, from `Info.plist`'s
    /// `DEFAULT_QUESTION_COUNT`. Used before the server's real count is known.
    static let defaultQuestionCount = Bundle.main.infoDictionary?["DEFAULT_QUESTION_COUNT"] as? Int ?? 5
}
