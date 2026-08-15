//
//  ListItemMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `ListItem` configuration (Figma).
///
/// Usage: `.padding(.trailing, ListItemMetrics.rowTrailingPadding)`.
enum ListItemMetrics {
    /// The label/description column's leading padding, used only when there's no
    /// `leadingIcon` (the icon supplies the row's leading edge itself otherwise).
    static let contentLeadingPadding: CGFloat = Spacing.lg
    /// The label/description column's top/bottom padding. Not part of the spacing scale —
    /// Figma specifies 17pt exactly.
    static let contentVerticalPadding: CGFloat = 17
    /// The label/description column's trailing padding — the minimum gap to `accessory`.
    static let contentAccessoryGap: CGFloat = Spacing.md
    /// The row's own trailing padding, from `accessory` to the row's edge.
    static let rowTrailingPadding: CGFloat = Spacing.lg
    /// Width and height the trailing chevron is resized to.
    static let chevronSize: CGFloat = 24
    /// Width and height `leadingIcon` is resized to.
    static let leadingIconSize: CGFloat = 40
    /// `leadingIcon`'s own leading padding.
    static let leadingIconLeadingPadding: CGFloat = Spacing.lg
    /// `leadingIcon`'s own trailing padding — the gap to the label/description column.
    static let leadingIconTrailingPadding: CGFloat = Spacing.md
}
