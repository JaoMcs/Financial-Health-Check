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

    /// Strings for the result screen (`ResultView`).
    enum Result {
        static let primaryButtonTitle = "Finish"
        static let secondaryButtonTitle = "Retake"
        static let maxScore = 100

        /// The headline shown for `category`, `nil` treated the same as `.poor`.
        ///
        /// - Parameter category: `ResultDTO.category`.
        static func title(for category: ResultCategory?) -> String {
            switch category {
            case .excellent:
                return "Excellent shape"
            case .good:
                return "Solid ground"
            case .fair:
                return "Making progress"
            case .poor, nil:
                return "Just starting out"
            }
        }

        /// The supporting copy shown for `category`, `nil` treated the same as `.poor`.
        ///
        /// - Parameter category: `ResultDTO.category`.
        static func description(for category: ResultCategory?) -> String {
            switch category {
            case .excellent:
                return "Strong savings, low debt, solid planning."
            case .good:
                return "Good habits, small gains still available."
            case .fair:
                return "Good start, some gaps worth closing."
            case .poor, nil:
                return "Small steps now go a long way."
            }
        }
    }

    /// Strings for the question screen (`QuestionaryView`). The question's own title,
    /// description, and options aren't here — they come from the API.
    enum Question {
        static let continueButtonTitle = "Continue"
        static let numberPrefix = "€"
        static let numberPlaceholder = "0"

        /// The nav bar title, e.g. "Question 3 of 5".
        ///
        /// - Parameters:
        ///   - current: How many questions are done.
        ///   - total: The flow's total question count.
        static func navigationTitle(current: Int, total: Int) -> String {
            "Question \(current) of \(total)"
        }

        /// The message shown below a `.number` question's field, stating its allowed range —
        /// shown regardless of validity; `QuestionaryViewModel.isNumberInvalid` is what colors
        /// it as an error.
        ///
        /// - Parameters:
        ///   - min: `QuestionValidationDTO.min`.
        ///   - max: `QuestionValidationDTO.max`.
        static func numberRangeMessage(min: Int, max: Int) -> String {
            "Enter a whole number between \(min) and \(max)."
        }
    }
}
