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
    /// The highest `value` `NavigationProgressBarView` accepts — full width, fully filled.
    static let maxValue = 6
}

/// The design system's navigation progress bar (Figma): `Primary.primary` (`#6334FF`) filling
/// over a `BorderAndIcon.border` (`#DAD7EE`) track, for screens in a fixed-length flow (e.g.
/// "question 3 of 5").
///
/// `value` runs `0...6`: `0` renders an empty fill (`NavigationHeader` is what actually hides
/// the bar, by collapsing its height to `0`), `1...5` fill it proportionally, and `6` is
/// fully filled — one past the flow's last step, for a "completed" screen that comes after it.
///
/// The fill is sized in `layoutSubviews` rather than with an Auto Layout multiplier, so
/// changing `value` never needs its constraint torn down and rebuilt — just
/// `layoutIfNeeded()`, which this animates so the fill visibly slides to its new width.
///
/// Usage: `progressBarView.value = 3` for "step 3 of 5".
final class NavigationProgressBarView: UIView {
    /// How much of the bar is filled, `0...6` (values outside that range are clamped).
    /// Animates the fill to its new width.
    var value: Int = 0 {
        didSet {
            setNeedsLayout()
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

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
        let clampedValue = min(max(value, 0), NavigationProgressBarMetrics.maxValue)
        return CGFloat(clampedValue) / CGFloat(NavigationProgressBarMetrics.maxValue)
    }
}
