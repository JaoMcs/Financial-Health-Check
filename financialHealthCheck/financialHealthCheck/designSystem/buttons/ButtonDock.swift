//
//  ButtonDock.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI

/// A `.primary` `AppButton` stacked on a `.secondary` one, `Spacing.sm` apart (Figma) — the
/// fixed "main action" / "alternate action" pair used to close out a flow.
struct ButtonDock: View {
    /// Label of the top, `.primary` button.
    let primaryText: String
    /// Label of the bottom, `.secondary` button.
    let secondaryText: String
    /// Called when the primary button is tapped.
    let primaryAction: () -> Void
    /// Called when the secondary button is tapped.
    let secondaryAction: () -> Void
    /// Whether the primary button can be tapped, independent of the secondary one.
    var isPrimaryEnabled: Bool = true
    /// Whether the secondary button can be tapped, independent of the primary one.
    var isSecondaryEnabled: Bool = true
    /// Icon shown to the left of `secondaryText`. `nil` omits it entirely.
    var secondaryLeadingIcon: Image?

    var body: some View {
        VStack(spacing: Spacing.sm) {
            AppButton(text: primaryText, type: .primary, action: primaryAction)
                .disabled(!isPrimaryEnabled)
            AppButton(
                text: secondaryText,
                leadingIcon: secondaryLeadingIcon,
                type: .secondary,
                action: secondaryAction
            )
            .disabled(!isSecondaryEnabled)
        }
        .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    ButtonDock(
        primaryText: "Continue",
        secondaryText: "Cancel",
        primaryAction: {},
        secondaryAction: {},
        isPrimaryEnabled: false
    )
}
