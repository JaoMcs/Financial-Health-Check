//
//  NavigationProgressBarView.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import UIKit

/// Layout values for `NavigationProgressBarView`.
enum NavigationProgressBarConstants {
    /// The view's height. Also its corner radius (half of it, on both the track and the
    /// fill), so both ends stay rounded.
    static let height: CGFloat = 4
    /// Duration of the fill's slide animation when `setProgress(current:total:)` changes it.
    static let animationDuration: TimeInterval = 0.3
}

/// The design system's navigation progress bar (Figma): a filled track for screens in a
/// fixed-length flow, e.g. "question 3 of 5".
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

    /// Sets how far along a `total`-step flow this screen is, animating the fill.
    ///
    /// - Parameters:
    ///   - current: How many steps are done. Clamped to `0...total`.
    ///   - total: The flow's total step count.
    func setProgress(current: Int, total: Int) {
        self.total = max(total, 0)
        self.current = min(max(current, 0), self.total)

        setNeedsLayout()
        UIView.animate(withDuration: NavigationProgressBarConstants.animationDuration) {
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
