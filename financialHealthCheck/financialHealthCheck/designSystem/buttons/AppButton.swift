//
//  AppButton.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI

/// Layout and behavior values shared by every `AppButtonStyle` variant (Figma).
///
/// Width isn't listed here: the button expands to fill all the width its parent gives it
/// (`AppButtonStyle` sets `maxWidth: .infinity`) rather than hugging its label. Keeping the
/// button flush with a screen's edges (Figma's 24pt margin) is the placing container's job —
/// e.g. `ButtonDock` applies that horizontal padding itself.
///
/// Usage: `.frame(minHeight: AppButtonConstants.height)`.
enum AppButtonConstants {
    /// Minimum leading/trailing padding between the label and the button's edge.
    static let horizontalPadding: CGFloat = 32
    /// Fixed (and minimum) button height.
    static let height: CGFloat = 60
    /// Spacing to use between an icon and a label when composing a button's content.
    static let gap: CGFloat = Spacing.sm
    /// Border width for variants that draw one (e.g. `.secondary`).
    static let borderWidth: CGFloat = 1.5
    /// Opacity applied to the whole button while `isEnabled == false`.
    static let disabledOpacity: Double = 0.5
    /// Opacity applied to the whole button while it's being pressed, giving tap feedback.
    static let pressedOpacity: Double = 0.7
    /// Duration of the press-feedback opacity animation.
    static let pressAnimationDuration: Double = 0.15
}

/// The three button looks the app uses. Each case maps to a fixed `AppButtonColors` set via
/// `colors`, kept as a separate type rather than nested in `AppButton` because a nested type
/// named `Type` would collide with Swift's own metatype syntax.
///
/// Usage: `type.colors`.
enum AppButtonType {
    /// Solid purple fill, white label — the default call-to-action.
    case primary
    /// White fill, purple outline and label — a secondary action next to a `.primary` button.
    case secondary
    /// Solid red fill, white label — for destructive/irreversible actions.
    case destructive

    /// The `AppButtonColors` set this case maps to.
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
/// The app only ever needs the three looks in `AppButtonType`, so `AppButton` owns wiring one
/// of them to `AppButtonStyle` internally rather than exposing `AppButtonStyle`/
/// `AppButtonColors` for callers to compose themselves.
///
/// Usage: see the `#Preview` below.
struct AppButton: View {
    /// The button's text, always shown.
    let text: String
    /// Icon shown to the left of `text`, 8pt away from it. `nil` omits it entirely.
    var leadingIcon: Image?
    /// Icon shown to the right of `text`, 8pt away from it. `nil` omits it entirely.
    var trailingIcon: Image?
    /// Which of the app's three looks to render.
    let type: AppButtonType
    /// Replaces the label with a spinner and disables the button — for an `action` that's
    /// mid-flight (e.g. a network call before navigating to the next screen).
    var isLoading: Bool = false
    /// Called when the button is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .tint(type.colors.foreground)
            } else {
                HStack(spacing: 0) {
                    leadingIcon?
                        .renderingMode(.template)
                        .padding(.trailing, AppButtonConstants.gap)
                    Text(text)
                    trailingIcon?
                        .renderingMode(.template)
                        .padding(.leading, AppButtonConstants.gap)
                }
            }
        }
        .buttonStyle(AppButtonStyle(colors: type.colors))
        .disabled(isLoading)
    }
}

/// Every `AppButtonType`, enabled, disabled, and loading, with both icons to exercise the
/// full layout and an overflowing label to confirm text truncates instead of wrapping.
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

            AppButton(
                text: entry.text,
                leadingIcon: Image(systemName: "star.fill"),
                trailingIcon: Image(systemName: "arrow.right"),
                type: entry.type,
                isLoading: true
            ) {}
        }
    }
    .padding(.horizontal, Spacing.twoXl)
}
