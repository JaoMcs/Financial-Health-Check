//
//  NavigationProgressBarView.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import UIKit

/// Layout values for `NavigationProgressBarView`. Not specified in Figma beyond the colors —
/// `height` is a small, reasonable pick and may need tuning once seen on device.
enum NavigationProgressBarMetrics {
    /// The view's height. Also its corner radius (half of it, on both the track and the
    /// fill), so both ends stay rounded.
    static let height: CGFloat = 4
}

/// The design system's navigation progress bar (Figma): `Primary.primary` (`#6334FF`) filling
/// over a `BorderAndIcon.border` (`#DAD7EE`) track, for screens in a fixed-length flow (e.g.
/// "question 3 of 5").
///
/// The fill is sized in `layoutSubviews` rather than with an Auto Layout multiplier, so
/// changing progress never needs its constraint torn down and rebuilt — just
/// `layoutIfNeeded()`, which this animates so the fill visibly slides to its new width.
///
/// Usage: `progressBarView.setProgress(current: 3, total: 5)` for "step 3 of 5".
final class NavigationProgressBarView: UIView {
    /// How many of `total` steps are done. Set via `setProgress(current:total:)`.
    private(set) var current = 0
    /// The flow's total step count. Set via `setProgress(current:total:)`.
    private(set) var total = 0

    private let trackView = UIView()
    private let fillView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    @available(*, unavailable, message: "Use init(frame:) instead.")
    required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets how far along a `total`-step flow this screen is, animating the fill to its new
    /// width.
    ///
    /// - Parameters:
    ///   - current: How many steps are done, e.g. `3` for "step 3 of 5". Clamped to
    ///     `0...total`.
    ///   - total: The flow's total step count.
    func setProgress(current: Int, total: Int) {
        self.total = max(total, 0)
        self.current = min(max(current, 0), self.total)

        setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        trackView.frame = bounds
        trackView.layer.cornerRadius = bounds.height / 2

        fillView.frame = CGRect(x: 0, y: 0, width: bounds.width * fraction, height: bounds.height)
        fillView.layer.cornerRadius = bounds.height / 2
    }

    private func setUpSubviews() {
        trackView.backgroundColor = DesignSystemColor.BorderAndIcon.uiBorder
        addSubview(trackView)

        fillView.backgroundColor = DesignSystemColor.Primary.uiPrimary
        addSubview(fillView)
    }

    private var fraction: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(current) / CGFloat(total)
    }
}
