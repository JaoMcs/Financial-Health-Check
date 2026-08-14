//
//  View+Typography.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// Applies a `TypographyToken`'s font, tracking, and line spacing in one modifier, instead of
/// setting each of those manually on every `Text`.
private struct TypographyModifier: ViewModifier {
    let token: TypographyToken

    func body(content: Content) -> some View {
        content
            .font(token.font)
            .tracking(token.tracking)
            .lineSpacing(token.lineSpacing)
    }
}

extension View {
    /// Styles this view with a design system `TypographyToken`.
    ///
    /// - Parameter token: The `TypographyToken` to apply (e.g. `Typography.Body.LG.regular`).
    ///
    /// Usage: `Text("Hi").typography(Typography.Body.LG.regular)`.
    func typography(_ token: TypographyToken) -> some View {
        modifier(TypographyModifier(token: token))
    }
}
