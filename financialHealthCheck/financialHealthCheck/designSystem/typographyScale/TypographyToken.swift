//
//  TypographyToken.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// A single text style from the design system: size, weight, line height, and letter
/// spacing.
///
/// Figma describes line height in px and letter spacing as a percentage of the font size;
/// this type stores the raw values and exposes them already converted to what SwiftUI
/// expects (`tracking` in points, `lineSpacing` as extra space between lines).
///
/// Usage: `.font(token.font).tracking(token.tracking).lineSpacing(token.lineSpacing)`.
struct TypographyToken {
    /// Font size in points.
    let size: CGFloat
    /// Font weight.
    let weight: Font.Weight
    /// Line height in points, as specified in Figma.
    let lineHeight: CGFloat
    /// Letter spacing as a fraction of `size` (e.g. `-0.02` for "-2%").
    let letterSpacingPercent: Double

    /// The SwiftUI font for this token.
    var font: Font {
        .system(size: size, weight: weight)
    }

    /// `letterSpacingPercent` converted to points, for use with `.tracking(_:)`.
    var tracking: CGFloat {
        CGFloat(letterSpacingPercent) * size
    }

    /// Extra space to add between lines, for use with `.lineSpacing(_:)`, so the resulting
    /// line height matches `lineHeight`.
    var lineSpacing: CGFloat {
        lineHeight - size
    }
}
