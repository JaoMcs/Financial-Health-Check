//
//  Palette.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's raw colors (Figma), one constant per unique hex value.
///
/// Semantic colors that share the same hex in Figma (e.g. Background and Surface, both
/// `#FFFFFF`) point at the same constant here, so a color only ever needs to change in one
/// place. Don't use these directly outside of `DesignSystemColor` — reach for the semantic
/// name that matches the context instead.
enum Palette {
    static let purple100 = Color(hex: "#EEE8FF")
    static let purple500 = Color(hex: "#6334FF")
    static let purple600 = Color(hex: "#4F20DC")

    static let white = Color(hex: "#FFFFFF")
    static let grey50 = Color(hex: "#F5F4FC")
    static let grey100 = Color(hex: "#E8E6F5")
    static let grey200 = Color(hex: "#DAD7EE")
    static let grey400 = Color(hex: "#A29BC8")
    static let grey500 = Color(hex: "#695F91")

    static let navy50 = Color(hex: "#F3EEFF")
    static let navy700 = Color(hex: "#261452")
    static let navy800 = Color(hex: "#1E0F44")
    static let navy900 = Color(hex: "#160A34")

    static let green500 = Color(hex: "#00DC82")
    static let amber500 = Color(hex: "#FFBE00")
    static let red500 = Color(hex: "#FF2D75")
    static let blue500 = Color(hex: "#007AFF")
}
