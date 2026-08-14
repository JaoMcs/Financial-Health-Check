//
//  Typography.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's typography scale, grouped by Figma category.
///
/// `Body.LG`, `Body.MD`, and `Body.SM` each hold a `.regular` and a `.medium` variant — in
/// Figma these are separate styles (e.g. `Body/LG` and `Body/LG-Medium`) that only differ in
/// weight and letter spacing, so they're unified here under one size.
///
/// Usage: `Text("Hi").typography(Typography.Body.LG.regular)`.
enum Typography {

    /// The large display sizes used for screen titles and section headers.
    enum Heading {
        static let xl = TypographyToken(size: 48, weight: .bold, lineHeight: 56, letterSpacingPercent: -0.02)
        static let lg = TypographyToken(size: 36, weight: .bold, lineHeight: 44, letterSpacingPercent: -0.015)
        static let md = TypographyToken(size: 30, weight: .bold, lineHeight: 38, letterSpacingPercent: -0.01)
        static let sm = TypographyToken(size: 24, weight: .semibold, lineHeight: 32, letterSpacingPercent: -0.005)
        static let xs = TypographyToken(size: 20, weight: .semibold, lineHeight: 28, letterSpacingPercent: -0.003)
    }

    /// The running-text sizes used for labels, inputs, and paragraph copy.
    enum Body {
        /// Body/LG and Body/LG-Medium.
        enum LG {
            static let regular = TypographyToken(size: 16, weight: .regular, lineHeight: 24, letterSpacingPercent: 0)
            static let medium = TypographyToken(size: 16, weight: .medium, lineHeight: 24, letterSpacingPercent: 0.002)
        }
        /// Body/MD and Body/MD-Medium.
        enum MD {
            static let regular = TypographyToken(size: 14, weight: .regular, lineHeight: 20, letterSpacingPercent: 0)
            static let medium = TypographyToken(size: 14, weight: .medium, lineHeight: 20, letterSpacingPercent: 0.002)
        }
        /// Body/SM and Body/SM-Medium.
        enum SM {
            static let regular = TypographyToken(size: 12, weight: .regular, lineHeight: 16, letterSpacingPercent: 0)
            static let medium = TypographyToken(size: 12, weight: .medium, lineHeight: 16, letterSpacingPercent: 0.002)
        }
    }
}
