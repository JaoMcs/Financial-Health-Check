//
//  Strings.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// Every user-facing string in the app, grouped by screen, so no screen hardcodes text
/// directly.
enum Strings {
    /// Strings for the intro screen (`StartView`).
    enum Start {
        static let title = "How healthy are your finances?"
        static let description = "5 questions, 2 minutes."
        static let buttonTitle = "Start"
    }
}
