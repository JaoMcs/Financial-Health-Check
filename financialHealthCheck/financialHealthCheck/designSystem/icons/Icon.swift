//
//  Icon.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// The design system's icons, one constant per asset in `Assets.xcassets`, so callers never
/// reference an asset's raw string name directly.
enum Icon {
    static let chevronDownSmall = Image("chevron-down-small")
    static let chevronTopSmall = Image("chevron-top-small")
    static let chevronRightSmall = Image("chevron-right-small")
    static let checkboxSelected = Image("checkboxSelected")
    static let checkboxNotSelected = Image("checkboxNotSelected")
    static let radioSelected = Image("radioSelected")
    static let radioNotSelected = Image("radioNotSelected")
    static let backArrow = Image("backArrow")
    static let arrowReturn = Image("arrow-return")
    static let trendUp = Image("trend-up")
    static let mainImage = Image("mainImage")
    static let rightArrowIcon = Image("right-arrow-icon")
    static let iconBackground = Image("iconBackground")
    static let iconNoInternet = Image("iconNoInternet")
    static let iconNoAvailable = Image("iconNoAvailable")
}
