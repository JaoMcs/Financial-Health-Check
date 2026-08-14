//
//  RadioButtonListItemMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `RadioButtonListItem` state (Figma).
///
/// Usage: `.padding(.leading, RadioButtonListItemMetrics.edgePadding)`.
enum RadioButtonListItemMetrics {
    /// Corner radius of the item's background/border.
    static let cornerRadius: CGFloat = 16
    /// The icon's top/leading/bottom padding, and the item's own trailing padding.
    static let edgePadding: CGFloat = Spacing.xl
    /// The icon's trailing padding — the gap between it and the label.
    static let iconLabelGap: CGFloat = Spacing.md
    /// Border width while unselected.
    static let borderWidth: CGFloat = 1
    /// Border width while selected.
    static let selectedBorderWidth: CGFloat = 2
}
