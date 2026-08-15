//
//  NavigationHeaderMetrics.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import UIKit

/// Layout values for `NavigationHeader`.
enum NavigationHeaderMetrics {
    /// Width given to the title label once installed as a screen's `titleView`.
    /// `UINavigationBar` doesn't hand its title view the bar's full width, so this isn't
    /// derived from Figma — it's a starting point. Confirm it on device/simulator and adjust
    /// if the title looks clipped or too narrow next to the back button.
    static let width: CGFloat = 240
}
