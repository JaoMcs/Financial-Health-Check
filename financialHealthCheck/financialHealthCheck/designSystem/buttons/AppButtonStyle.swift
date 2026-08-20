//
//  AppButtonStyle.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's shared button shape: pill-shaped, fixed height, expands to fill all
/// available width, `Body/MD-Medium` typography, single-line label (truncates rather than
/// wrapping), dimmed-opacity tap feedback, and 50% opacity while disabled.
///
/// Only `colors` changes between the `.primary`, `.secondary`, and `.destructive` variants
/// exposed on `ButtonStyle` — see `AppButtonColors`.
///
/// Usage: `.buttonStyle(AppButtonStyle(colors: .primary))`.
struct AppButtonStyle: ButtonStyle {
    /// The fill/foreground/border set this instance renders — see `AppButtonColors`.
    let colors: AppButtonColors

    /// Builds the button's body for `configuration`, as required by `ButtonStyle`.
    ///
    /// - Parameter configuration: The `ButtonStyleConfiguration` SwiftUI passes in, holding
    ///   the button's `label` and `isPressed` state.
    func makeBody(configuration: Configuration) -> some View {
        AppButtonBody(configuration: configuration, colors: colors)
    }
}

/// Renders `AppButtonStyle`'s configuration. A separate `View` is needed to read
/// `@Environment(\.isEnabled)`, which `ButtonStyle.makeBody` doesn't receive directly.
private struct AppButtonBody: View {
    let configuration: AppButtonStyle.Configuration
    let colors: AppButtonColors

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .typography(Typography.Body.MD.medium)
            .foregroundStyle(colors.foreground)
            .lineLimit(1)
            .padding(.horizontal, AppButtonConstants.horizontalPadding)
            .frame(maxWidth: .infinity, minHeight: AppButtonConstants.height)
            .background(colors.background)
            .overlay(
                Capsule()
                    .strokeBorder(colors.border, lineWidth: AppButtonConstants.borderWidth)
            )
            .clipShape(Capsule())
            .opacity(opacity)
            .animation(.easeOut(duration: AppButtonConstants.pressAnimationDuration), value: configuration.isPressed)
    }

    /// Full opacity unless disabled (`disabledOpacity`) or, while enabled, mid-press
    /// (`pressedOpacity`).
    private var opacity: Double {
        guard isEnabled else { return AppButtonConstants.disabledOpacity }
        return configuration.isPressed ? AppButtonConstants.pressedOpacity : 1
    }
}
