//
//  UILabel+Typography.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import UIKit

extension UILabel {
    /// Sets `text` styled with a design system `TypographyToken` and color — the UIKit
    /// counterpart to `View.typography(_:)`.
    ///
    /// - Parameters:
    ///   - text: The string to display.
    ///   - token: The `TypographyToken` to style it with.
    ///   - color: The text color.
    ///   - alignment: Baked into the attributed string's paragraph style. Defaults to
    ///     `.natural`.
    func setText(
        _ text: String,
        typography token: TypographyToken,
        color: UIColor,
        alignment: NSTextAlignment = .natural
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = token.lineSpacing
        paragraphStyle.alignment = alignment

        attributedText = NSAttributedString(string: text, attributes: [
            .font: token.uiFont,
            .kern: token.tracking,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: color
        ])
    }
}
