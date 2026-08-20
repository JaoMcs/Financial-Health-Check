//
//  AppButtonColors.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The colors that distinguish one `AppButtonStyle` variant from another: fill, label/icon
/// color, and outline.
struct AppButtonColors {
    /// The button's fill.
    let background: Color
    /// The label and icon color.
    let foreground: Color
    /// The outline color. Only visible on "hollow" variants (e.g. `.secondary`) — solid-fill
    /// variants set this to `.clear` since the fill already reads as the shape.
    let border: Color
}

extension AppButtonColors {
    /// Solid purple fill, white label. The app's default call-to-action.
    static let primary = AppButtonColors(
        background: DesignSystemColor.Primary.primary,
        foreground: DesignSystemColor.Text.onPrimary,
        border: .clear
    )

    /// White fill with a purple outline and label — the "hollow" variant, used for a
    /// secondary action next to a `.primary` button.
    static let secondary = AppButtonColors(
        background: DesignSystemColor.BackgroundAndSurface.background,
        foreground: DesignSystemColor.Primary.primary,
        border: DesignSystemColor.Primary.primary
    )

    /// Solid red fill, white label. For destructive/irreversible actions.
    static let destructive = AppButtonColors(
        background: DesignSystemColor.Status.error,
        foreground: DesignSystemColor.Text.onPrimary,
        border: .clear
    )
}
