//
//  MainIcon.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// The design system's icon-on-circle composition (Figma): `Icon.iconBackground`'s gradient
/// circle with `icon` centered on top — both rendered at their asset's own size, so neither
/// needs an explicit `frame`.
///
/// - Parameter icon: The icon shown centered over `Icon.iconBackground`, e.g.
///   `Icon.iconNoInternet`.
///
/// Usage: `MainIcon(icon: Icon.iconNoInternet)`.
struct MainIcon: View {
    let icon: Image

    var body: some View {
        ZStack {
            Icon.iconBackground
            icon
        }
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        MainIcon(icon: Icon.iconNoInternet)
        MainIcon(icon: Icon.iconNoAvailable)
    }
}
