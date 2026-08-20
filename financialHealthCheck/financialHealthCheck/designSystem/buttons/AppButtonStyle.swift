//
//  AppButtonStyle.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's shared button shape: pill-shaped, fixed height, full width,
/// `Body/MD-Medium` typography, single-line label, dimmed-opacity tap feedback, and 50%
/// opacity while disabled.
struct AppButtonStyle: ButtonStyle {
    /// The fill/foreground/border set this instance renders.
    let colors: AppButtonColors

    /// Builds the button's body for `configuration`.
    func makeBody(configuration: Configuration) -> some View {
        AppButtonBody(configuration: configuration, colors: colors)
    }
}

/// Renders `AppButtonStyle`'s configuration — a separate `View` so it can read
/// `@Environment(\.isEnabled)`.
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
