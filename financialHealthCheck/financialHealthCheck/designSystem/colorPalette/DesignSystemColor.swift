//
//  DesignSystemColor.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import SwiftUI

/// The design system's semantic colors, grouped by Figma category.
///
/// Each name points at a `Palette` constant — the hex value only exists in one place;
/// pick whichever name reads best for the context you're styling (e.g. `Text.primary` for
/// a label, `Status.error` for a validation message).
enum DesignSystemColor {

    /// Category Primary.
    enum Primary {
        static let primary = Palette.purple500
        static let hover = Palette.purple600
        static let subtle = Palette.purple100
    }

    /// Category: Background and Surface.
    enum BackgroundAndSurface {
        static let background = Palette.white
        static let backgroundSecondary = Palette.grey50
        static let backgroundTertiary = Palette.grey100
        static let surface = Palette.white
    }

    /// Category: Text.
    enum Text {
        static let primary = Palette.navy900
        static let secondary = Palette.grey500
        static let tertiary = Palette.grey400
        static let onPrimary = Palette.white
        static let onDark = Palette.white
    }

    /// Category: Border and Icon.
    enum BorderAndIcon {
        static let border = Palette.grey200
        static let borderStrong = Palette.grey400
        static let iconPrimary = Palette.navy900
        static let iconSecondary = Palette.grey500
    }

    /// Category: Status.
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
