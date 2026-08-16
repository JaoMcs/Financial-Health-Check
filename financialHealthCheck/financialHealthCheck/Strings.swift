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

    /// Strings for the result screen (`ResultView`). `title`/`description` aren't here — they
    /// come from the API and vary with the result's category.
    enum Result {
        static let primaryButtonTitle = "Finish"
        static let secondaryButtonTitle = "Retake"
    }

    /// Strings for the question screen (`QuestionaryView`). The question's own title,
    /// description, and options aren't here — they come from the API.
    enum Question {
        static let continueButtonTitle = "Continue"
        /// Placeholder nav title until a real per-question title is wired in.
        static let navigationTitle = "Question"
    }
}
