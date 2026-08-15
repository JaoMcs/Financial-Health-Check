//
//  UILabel+Typography.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI
import UIKit

extension UILabel {
    /// Sets `text` styled with a design system `TypographyToken` and color — the UIKit
    /// counterpart to `View.typography(_:)`, for text hosted outside of SwiftUI (e.g.
    /// `NavigationHeader`'s title).
    ///
    /// - Parameters:
    ///   - text: The string to display.
    ///   - token: The `TypographyToken` to style it with (e.g. `Typography.Body.MD.medium`).
    ///   - color: The text color.
    ///   - alignment: Baked into the attributed string's paragraph style — setting
    ///     `textAlignment` instead doesn't reliably apply once `attributedText` is set.
    ///     Defaults to `.natural`.
    ///
    /// Usage: `label.setText("Income", typography: Typography.Body.MD.medium, color:
    /// DesignSystemColor.Text.primary, alignment: .center)`.
    func setText(
        _ text: String,
        typography token: TypographyToken,
        color: Color,
        alignment: NSTextAlignment = .natural
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = token.lineSpacing
        paragraphStyle.alignment = alignment

        attributedText = NSAttributedString(string: text, attributes: [
            .font: token.uiFont,
            .kern: token.tracking,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(color)
        ])
    }
}
