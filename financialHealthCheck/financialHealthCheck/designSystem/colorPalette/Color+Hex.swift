//
//  Color+Hex.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

extension Color {
    /// Creates a `Color` from a `"#RRGGBB"` (or `"RRGGBB"`) hex string, as used by the
    /// Figma design system. Alpha is always fully opaque.
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
