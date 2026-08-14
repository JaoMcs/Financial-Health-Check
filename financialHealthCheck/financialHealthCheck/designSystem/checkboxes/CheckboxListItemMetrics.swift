//
//  CheckboxListItemMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `CheckboxListItem` state (Figma).
///
/// Usage: `.padding(.leading, CheckboxListItemMetrics.iconLeadingPadding)`.
enum CheckboxListItemMetrics {
    /// Corner radius of the item's background/border.
    static let cornerRadius: CGFloat = 16
    /// Width and height the checkbox icon is resized to.
    static let iconSize: CGFloat = 24
    /// The icon's leading padding, and the item's own trailing padding.
    static let iconLeadingPadding: CGFloat = Spacing.xl
    /// The icon's top/bottom padding.
    static let iconVerticalPadding: CGFloat = Spacing.twoXl
    /// The icon's trailing padding — the gap between it and the label. Not specified in
    /// Figma — reuses `RadioButtonListItem`'s icon/label gap.
    static let iconLabelGap: CGFloat = Spacing.md
    /// Border width while unchecked.
    static let borderWidth: CGFloat = 1
    /// Border width while checked.
    static let checkedBorderWidth: CGFloat = 2
}
