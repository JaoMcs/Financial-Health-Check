//
//  AppSelectControlMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `AppSelectControl` state (Figma).
///
/// Usage: `.padding(.horizontal, AppSelectControlMetrics.horizontalPadding)`.
enum AppSelectControlMetrics {
    /// Corner radius of the trigger and of the options list as a whole.
    static let cornerRadius: CGFloat = 16
    /// Leading/trailing padding between the trigger's content and its edge, and between an
    /// option row's content and its edge.
    static let horizontalPadding: CGFloat = Spacing.lg
    /// Top/bottom padding for the trigger and for each option row. Not specified in Figma —
    /// reuses `AppTextField`'s vertical padding to keep both controls the same height.
    static let verticalPadding: CGFloat = Spacing.md
    /// Border width for the trigger's default and error states.
    static let borderWidth: CGFloat = 1
    /// Border width for the trigger once it's open or in its error state.
    static let openOrErrorBorderWidth: CGFloat = 2
    /// Gap between the trigger and the options list once open.
    static let optionsGap: CGFloat = Spacing.xs
}
