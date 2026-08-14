//
//  AppButton.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI

/// The three button looks the app uses, each mapping to a fixed `AppButtonColors` set.
///
/// Kept outside `AppButton` rather than nested (e.g. `AppButton.Type`) — a nested type
/// named `Type` would collide with Swift's own metatype syntax (`AppButton.Type` already
/// means "the metatype of `AppButton`").
enum AppButtonType {
    /// Solid purple fill, white label — the default call-to-action.
    case primary
    /// White fill, purple outline and label — a secondary action next to a `.primary` button.
    case secondary
    /// Solid red fill, white label — for destructive/irreversible actions.
    case destructive

    var colors: AppButtonColors {
        switch self {
        case .primary: .primary
        case .secondary: .secondary
        case .destructive: .destructive
        }
    }
}

/// The design system's single button component (Figma): pill-shaped, single-line text with
/// an optional icon on either side, the tap animation of a real `Button`, and 50% opacity
/// while disabled via the standard `.disabled(_:)` modifier.
///
/// The app only ever needs the three looks in `AppButtonType`, so `AppButton` owns wiring
/// one of them to `AppButtonStyle` internally rather than exposing `AppButtonStyle`/
/// `AppButtonColors` for callers to compose themselves.
struct AppButton: View {
    /// The button's text, always shown.
    let text: String
    /// Icon shown to the left of `text`, 8pt away from it. `nil` omits it entirely.
    var leadingIcon: Image? = nil
    /// Icon shown to the right of `text`, 8pt away from it. `nil` omits it entirely.
    var trailingIcon: Image? = nil
    /// Which of the app's three looks to render.
    let type: AppButtonType
    /// Called when the button is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                leadingIcon?
                    .padding(.trailing, AppButtonMetrics.gap)
                Text(text)
                trailingIcon?
                    .padding(.leading, AppButtonMetrics.gap)
            }
        }
        .buttonStyle(AppButtonStyle(colors: type.colors))
    }
}

/// Every `AppButtonType`, enabled and disabled, with both icons to exercise the full layout
/// and an overflowing label to confirm text truncates instead of wrapping.
#Preview {
    let entries: [(text: String, type: AppButtonType)] = [
        ("Primary teste text big enough to overflow", .primary),
        ("Secondary", .secondary),
        ("Destructive regular size text", .destructive)
    ]

    VStack(spacing: Spacing.lg) {
        ForEach(entries, id: \.text) { entry in
            AppButton(
                text: entry.text,
                leadingIcon: Image(systemName: "star.fill"),
                trailingIcon: Image(systemName: "arrow.right"),
                type: entry.type
            ) {}

            AppButton(
                text: entry.text,
                leadingIcon: Image(systemName: "star.fill"),
                trailingIcon: Image(systemName: "arrow.right"),
                type: entry.type
            ) {}
            .disabled(true)
        }
    }
    .padding(.horizontal, Spacing.twoXl)
}
