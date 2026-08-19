//
//  ErrorView.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// The presentation `ErrorView` actually varies on. Several `NetworkError` cases collapse
/// into the same one below when the user has nothing different to do about them — see
/// `init(_:)` — keeping the app down to a handful of distinct messages/icons instead of one
/// per `NetworkError` case.
enum ErrorViewKind {
    /// `.transport` — no connectivity, or the request timed out.
    case offline
    /// `.sessionNotFound`, `.invalidSessionId`, `.invalidQuestion`, `.questionNotFound` — the
    /// app's local reference to where the user was doesn't match the server anymore; nothing
    /// to do but start over.
    case sessionLost
    /// `.sessionAlreadyCompleted` — the session still exists, but was already finished.
    case sessionCompleted
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
        case .sessionNotFound, .invalidSessionId, .invalidQuestion, .questionNotFound:
            self = .sessionLost
        case .sessionAlreadyCompleted:
            self = .sessionCompleted
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
        case .sessionLost, .sessionCompleted:
            return Icon.iconNoAvailable
        case .offline, .rateLimited, .unexpected, .invalidAnswer:
            return Icon.iconNoInternet
        }
    }

    var title: String { Strings.Error.title(for: self) }
    var description: String { Strings.Error.description(for: self) }
    var buttonTitle: String { Strings.Error.buttonTitle(for: self) }
}

/// What a screen shows in place of its normal content when its ViewModel's `state` is
/// `.error`: a `MainIcon`/`ScreenHeader` pair and a primary button pinned to the bottom edge,
/// all driven by `error` alone via `ErrorViewKind`.
struct ErrorView: View {
    let error: NetworkError
    /// Called when the button ("Try Again"/"Start a new check", depending on `error`) is
    /// tapped.
    let action: () -> Void

    private var kind: ErrorViewKind { ErrorViewKind(error) }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                MainIcon(icon: kind.icon)
                    .padding(.bottom, Spacing.threeXl)

                ScreenHeader(caption: nil, title: kind.title, description: kind.description)
                    .padding()
            }

            Spacer()

            AppButton(text: kind.buttonTitle, type: .primary, action: action)
                .padding(.horizontal, Spacing.twoXl)
        }
    }
}

#Preview("Connectivity") {
    ErrorView(error: .transport(URLError(.notConnectedToInternet))) {}
}

#Preview("Session gone") {
    ErrorView(error: .sessionNotFound) {}
}

#Preview("Already completed") {
    ErrorView(error: .sessionAlreadyCompleted) {}
}
