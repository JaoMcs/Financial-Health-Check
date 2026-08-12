//
//  AppButtonMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// Layout and behavior values shared by every `AppButtonStyle` variant (Figma).
///
/// Width isn't listed here: Figma specifies "hug" sizing, which is what a button already
/// does by default in SwiftUI as long as nothing forces a `maxWidth` on it — the ~185px
/// shown in Figma is just the result for that frame's placeholder label, not a fixed value
/// to keep.
enum AppButtonMetrics {
    /// Leading/trailing padding around the label.
    static let horizontalPadding: CGFloat = 32
    /// Fixed (and minimum) button height.
    static let height: CGFloat = 60
    /// Spacing to use between an icon and a label when composing a button's content.
    static let gap: CGFloat = Spacing.sm
    /// Border width for variants that draw one (e.g. `.secondary`).
    static let borderWidth: CGFloat = 1.5
    /// Opacity applied to the whole button while `isEnabled == false`.
    static let disabledOpacity: Double = 0.5
}
