//
//  AppButtonMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// Layout and behavior values shared by every `AppButtonStyle` variant (Figma).
///
/// Width isn't listed here: the button expands to fill all the width its parent gives it
/// (`AppButtonStyle` sets `maxWidth: .infinity`) rather than hugging its label. Keeping the
/// button flush with a screen's edges (Figma's 24pt margin) is the placing container's job —
/// e.g. `ButtonDock` applies that horizontal padding itself.
enum AppButtonMetrics {
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
