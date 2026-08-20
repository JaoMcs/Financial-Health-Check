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
    /// `HealthCheckSessionDTO.status`'s two raw values — not user-facing text, but the API's
    /// own contract strings. Centralized here (`AppCoordinator`/`QuestionaryViewModel` compare
    /// against these instead of repeating the literals) rather than modeled as a `Codable`
    /// enum, to keep `status`'s decoding exactly as lenient as before.
    enum SessionStatus {
        static let inProgress = "in_progress"
        static let completed = "completed"
    }

    /// Strings for the intro screen (`StartView`).
    enum Start {
        static let title = "How healthy are your finances?"
        static let description = "\(AppConfig.defaultQuestionCount) questions, 2 minutes."
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

    /// Strings for `ErrorView`, shown in place of a screen's content when its ViewModel's
    /// `state` is `.error`.
    enum Error {
        /// The headline shown for `kind`.
        ///
        /// - Parameter kind: The `ErrorViewKind` `ErrorView` mapped its `NetworkError` to.
        static func title(for kind: ErrorViewKind) -> String {
            switch kind {
            case .offline:
                return "We couldn't reach the server"
            case .sessionLost:
                return "This check is no longer available"
            case .sessionCompleted:
                return "This check is already complete"
            case .questionOutOfSync:
                return "You've already answered this"
            case .rateLimited:
                return "Too many attempts"
            case .unexpected:
                return "Something went wrong"
            case .invalidAnswer:
                return "We couldn't submit your answer"
            }
        }

        /// The supporting copy shown for `kind`.
        ///
        /// - Parameter kind: The `ErrorViewKind` `ErrorView` mapped its `NetworkError` to.
        static func description(for kind: ErrorViewKind) -> String {
            switch kind {
            case .offline:
                return "Check your connection and try again. Your answers are saved on this device."
            case .sessionLost:
                return "We couldn't find your saved session on the server. Starting again takes about two minutes."
            case .sessionCompleted:
                return "You've already finished this health check. Start a new one to check again."
            case .questionOutOfSync:
                return "This question isn't part of the flow anymore — you may have gone back to " +
                    "an earlier step. Start a new check to continue."
            case .rateLimited:
                return "You've made too many requests in a short time. Wait a moment and try again."
            case .unexpected:
                return "An unexpected error occurred. Try again in a moment."
            case .invalidAnswer(let message):
                return message ?? "Double-check your answer and try again."
            }
        }

        /// The button label shown for `kind` — "Start a new check" when the session/flow
        /// itself is gone and has to restart, "Try Again" for every other (transient/
        /// server-side) failure.
        ///
        /// - Parameter kind: The `ErrorViewKind` `ErrorView` mapped its `NetworkError` to.
        static func buttonTitle(for kind: ErrorViewKind) -> String {
            switch kind {
            case .sessionLost, .sessionCompleted, .questionOutOfSync:
                return "Start a new check"
            case .offline, .rateLimited, .unexpected, .invalidAnswer:
                return "Try Again"
            }
        }
    }

    /// Strings for `RestoringSessionView`, shown right after splash while a persisted session
    /// is being resumed.
    enum RestoringSession {
        static let title = "Picking up where you left off"
        static let description = "Restoring your answers from this device."
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
            "Enter a number between \(min) and \(max)."
        }
    }
}
