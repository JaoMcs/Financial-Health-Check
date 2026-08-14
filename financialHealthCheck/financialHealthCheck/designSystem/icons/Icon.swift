//
//  Icon.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// The design system's icons, one constant per asset in `Assets.xcassets`, so callers never
/// reference an asset's raw string name directly.
///
/// Usage: `Icon.chevronDownSmall` instead of `Image("chevron-down-small")`.
enum Icon {
    static let chevronDownSmall = Image("chevron-down-small")
    static let chevronTopSmall = Image("chevron-top-small")
    static let checkboxSelected = Image("checkboxSelected")
    static let checkboxNotSelected = Image("checkboxNotSelected")
    static let radioSelected = Image("radioSelected")
    static let radioNotSelected = Image("radioNotSelected")
}
