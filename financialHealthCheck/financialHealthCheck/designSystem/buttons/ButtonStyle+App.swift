//
//  ButtonStyle+App.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// Ergonomic access to the design system's button styles, mirroring how SwiftUI exposes
/// its own built-in styles (e.g. `.buttonStyle(.bordered)`).
///
/// Usage: `Button("Continue") { ... }.buttonStyle(.primary)`.
extension ButtonStyle where Self == AppButtonStyle {
    /// Solid purple fill, white label — the default call-to-action.
    static var primary: AppButtonStyle { AppButtonStyle(colors: .primary) }
    /// White fill, purple outline and label — a secondary action next to a `.primary` button.
    static var secondary: AppButtonStyle { AppButtonStyle(colors: .secondary) }
    /// Solid red fill, white label — for destructive/irreversible actions.
    static var destructive: AppButtonStyle { AppButtonStyle(colors: .destructive) }
}
