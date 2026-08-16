//
//  DesignSystemColor.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI
import UIKit

/// The design system's semantic colors, grouped by Figma category.
///
/// Each name points at a `Palette` constant — the hex value only exists in one place; pick
/// whichever name reads best for the context you're styling.
///
/// Usage: `Text.primary` for a label, `Status.error` for a validation message.
///
/// A few entries also have a `ui`-prefixed `UIColor` counterpart (e.g. `Text.uiPrimary`), for
/// UIKit code that needs to stay free of a SwiftUI import (e.g. `NavigationHeader`,
/// `NavigationProgressBarView`) — added only for the colors a UIKit consumer actually uses,
/// same reasoning as `TypographyToken.uiFont`.
enum DesignSystemColor {

    /// Brand color and its interaction states (hover, subtle background).
    enum Primary {
        static let primary = Palette.purple500
        static let uiPrimary = UIColor(primary)
        static let hover = Palette.purple600
        static let subtle = Palette.purple100
    }

    /// Screen and surface fills, from the base background to its layered tiers.
    enum BackgroundAndSurface {
        static let background = Palette.white
        static let backgroundSecondary = Palette.grey50
        static let backgroundTertiary = Palette.grey100
        static let surface = Palette.white
    }

    /// Label colors, including the variants used on filled/dark backgrounds.
    enum Text {
        static let primary = Palette.navy900
        static let uiPrimary = UIColor(primary)
        static let secondary = Palette.grey500
        static let tertiary = Palette.grey400
        static let onPrimary = Palette.white
        static let onDark = Palette.white
    }

    /// Outline and icon colors shared by inputs, dividers, and glyphs.
    enum BorderAndIcon {
        static let border = Palette.grey200
        static let uiBorder = UIColor(border)
        static let borderStrong = Palette.grey400
        static let iconPrimary = Palette.navy900
        static let iconSecondary = Palette.grey500
    }

    /// Feedback colors — success/warning/error/info states, plus the dark and selected
    /// backgrounds used elsewhere in the app.
    enum Status {
        static let success = Palette.green500
        static let warning = Palette.amber500
        static let error = Palette.red500
        static let info = Palette.blue500
        static let darkBackground = Palette.navy800
        static let selected = Palette.navy700
        static let selectedSubtle = Palette.navy50
    }
}
