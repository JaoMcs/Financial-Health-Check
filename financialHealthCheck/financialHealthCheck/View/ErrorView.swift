//
//  ErrorView.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// Shown in place of a screen's content when its ViewModel's `state` is `.error` — a
/// `MainIcon`/`ScreenHeader` pair and a primary button, driven by `error` via `ErrorViewKind`.
struct ErrorView: View {
    let error: NetworkError
    /// Called when the button is tapped.
    let action: () -> Void

    private var kind: ErrorViewKind { ErrorViewKind(error) }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: Spacing.threeXl) {
                MainIcon(icon: kind.icon)

                ScreenHeader(caption: nil, title: kind.title, description: kind.description)
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
