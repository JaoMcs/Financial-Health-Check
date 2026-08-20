//
//  TypographyToken.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI
import UIKit

/// A single text style: size, weight, line height, and letter spacing, exposed already
/// converted to what SwiftUI expects.
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

    /// The `UIFont` equivalent of `font`, for UIKit-hosted text.
    var uiFont: UIFont {
        let uiWeight: UIFont.Weight
        switch weight {
        case .bold: uiWeight = .bold
        case .semibold: uiWeight = .semibold
        case .medium: uiWeight = .medium
        default: uiWeight = .regular
        }
        return .systemFont(ofSize: size, weight: uiWeight)
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
