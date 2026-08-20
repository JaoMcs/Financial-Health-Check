//
//  ErrorViewKind.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// The presentation `ErrorView` varies on. Several `NetworkError` cases collapse into the same
/// kind when the user has nothing different to do about them.
enum ErrorViewKind {
    /// `.transport` — no connectivity, or the request timed out.
    case offline
    /// `.sessionNotFound`, `.invalidSessionId`, `.questionNotFound` — the app's local
    /// reference to where the user was doesn't match the server anymore; nothing to do but
    /// start over.
    case sessionLost
    /// `.sessionAlreadyCompleted` — the session still exists, but was already finished.
    case sessionCompleted
    /// `.invalidQuestion` — the session is still valid; the answer was submitted for a
    /// question that's no longer the current one (e.g. the user went back and resubmitted).
    case questionOutOfSync
    /// `.rateLimited` — too many requests in a short time.
    case rateLimited
    /// `.invalidResponse`, `.decodingFailed`, `.methodNotAllowed`, `.unrecognizedServerError`
    /// — failures the user can't act on any differently than retrying.
    case unexpected
    /// `.validationError` — carries the server's own message, when it sent one.
    case invalidAnswer(message: String?)

    /// Maps `error` to the case that shares its presentation.
    ///
    /// - Parameter error: The `NetworkError` `ErrorView` was given.
    init(_ error: NetworkError) {
        switch error {
        case .transport:
            self = .offline
        case .sessionNotFound, .invalidSessionId, .questionNotFound:
            self = .sessionLost
        case .sessionAlreadyCompleted:
            self = .sessionCompleted
        case .invalidQuestion:
            self = .questionOutOfSync
        case .rateLimited:
            self = .rateLimited
        case .invalidResponse, .decodingFailed, .methodNotAllowed, .unrecognizedServerError:
            self = .unexpected
        case .validationError(_, let message):
            self = .invalidAnswer(message: message)
        }
    }

    /// One of the app's two error-state icons: `Icon.iconNoAvailable` when the session/flow
    /// itself is gone, `Icon.iconNoInternet` for every other failure.
    var icon: Image {
        switch self {
        case .sessionLost, .sessionCompleted, .questionOutOfSync:
            return Icon.iconNoAvailable
        case .offline, .rateLimited, .unexpected, .invalidAnswer:
            return Icon.iconNoInternet
        }
    }

    /// Whether this kind's primary action clears the session and starts a new one, rather than
    /// retrying the operation that just failed.
    var requiresSessionReset: Bool {
        switch self {
        case .sessionLost, .sessionCompleted, .questionOutOfSync:
            return true
        case .offline, .rateLimited, .unexpected, .invalidAnswer:
            return false
        }
    }

    var title: String { Strings.Error.title(for: self) }
    var description: String { Strings.Error.description(for: self) }
    var buttonTitle: String { Strings.Error.buttonTitle(for: self) }
}
