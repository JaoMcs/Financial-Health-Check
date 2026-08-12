//
//  AppButtonStyle.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's shared button shape: pill-shaped, fixed height, horizontal
/// padding, `Body/MD-Medium` typography, and 50% opacity while disabled.
///
/// Only `colors` changes between the `.primary`, `.secondary`, and `.destructive`
/// variants exposed on `ButtonStyle` — see `AppButtonColors`.
struct AppButtonStyle: ButtonStyle {
    let colors: AppButtonColors

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
            .padding(.horizontal, AppButtonMetrics.horizontalPadding)
            .frame(minHeight: AppButtonMetrics.height)
            .background(colors.background)
            .overlay(
                Capsule()
                    .strokeBorder(colors.border, lineWidth: AppButtonMetrics.borderWidth)
            )
            .clipShape(Capsule())
            .opacity(isEnabled ? 1 : AppButtonMetrics.disabledOpacity)
    }
}
