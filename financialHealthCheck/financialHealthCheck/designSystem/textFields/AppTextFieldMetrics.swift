//
//  AppTextFieldMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI

/// Layout values shared by every `AppTextField` configuration (Figma).
///
/// Usage: `.padding(.horizontal, AppTextFieldMetrics.horizontalPadding)`.
enum AppTextFieldMetrics {
    /// Corner radius of the field's background/border.
    static let cornerRadius: CGFloat = 16
    /// Leading/trailing padding between the field's content and its edge.
    static let horizontalPadding: CGFloat = Spacing.lg
    /// Top/bottom padding between the field's content and its edge. Not specified in Figma —
    /// chosen to keep the field comfortably tall next to `horizontalPadding`.
    static let verticalPadding: CGFloat = Spacing.md
    /// Border width for the default state.
    static let borderWidth: CGFloat = 1
    /// Border width once the field has an `errorMessage`.
    static let errorBorderWidth: CGFloat = 2
    /// Gap between the field and its `label` (above) or `errorMessage` (below).
    static let labelGap: CGFloat = Spacing.xs
    /// Gap between an optional `prefix` and the input text. Not specified in Figma — reuses
    /// the same gap `AppButton` uses between an icon and its label.
    static let prefixGap: CGFloat = Spacing.sm
}
