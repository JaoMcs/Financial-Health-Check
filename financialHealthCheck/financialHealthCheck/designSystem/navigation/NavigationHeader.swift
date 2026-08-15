//
//  NavigationHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI
import UIKit

/// Owns a screen's title, progress bar, and back button, and installs all three onto its
/// `navigationItem`/view — the one place that configures a custom header, so no screen wires
/// up its own title view, progress bar, or back button individually.
///
/// The title is a `UILabel` styled via `Typography.Body.MD.medium`/`Text.primary`, set as
/// `viewController.navigationItem.titleView`. `NavigationProgressBarView` can't live there
/// too — a `titleView` sits between the bar's leading/trailing items, never reaching the
/// screen's actual edges — so `install(on:)` instead adds it as a full-width subview pinned
/// to `viewController.view.safeAreaLayoutGuide`'s leading and trailing anchors, directly
/// below the navigation bar.
///
/// Every screen that uses this gets the exact same back button (`backArrow`, matching
/// `Icon.backArrow`), wired to pop the screen it's installed on — there's no per-screen
/// customization for it, matching Figma, where the back button never changes. `UIBarButtonItem`
/// needs a `UIImage` rather than a SwiftUI `Image`, which is why this reaches for the asset by
/// name instead of reusing `Icon.backArrow` directly.
///
/// Usage:
/// ```swift
/// let header = NavigationHeader(title: "Income", progress: 2)
/// header.install(on: self)
/// ```
final class NavigationHeader {
    private let titleLabel = UILabel()
    private let progressBarView = NavigationProgressBarView()
    private var progressBarHeightConstraint: NSLayoutConstraint?

    /// - Parameters:
    ///   - title: The screen's title.
    ///   - progress: Forwarded to `NavigationProgressBarView`. `0` (the default) hides the
    ///     progress bar entirely.
    init(title: String, progress: Int = 0) {
        titleLabel.setText(
            title,
            typography: Typography.Body.MD.medium,
            color: DesignSystemColor.Text.primary,
            alignment: .center
        )
        progressBarView.value = progress
    }

    /// Updates the title/progress in place. Call this instead of creating a new header when a
    /// screen's progress changes after it's already on screen (e.g. the Coordinator
    /// recalculating it after a pop).
    ///
    /// - Parameters:
    ///   - title: The screen's title.
    ///   - progress: Forwarded to `NavigationProgressBarView`. `0` hides the progress bar.
    func update(title: String, progress: Int) {
        titleLabel.setText(
            title,
            typography: Typography.Body.MD.medium,
            color: DesignSystemColor.Text.primary,
            alignment: .center
        )
        progressBarView.value = progress
        progressBarHeightConstraint?.constant = progress > 0 ? NavigationProgressBarMetrics.height : 0
    }

    /// Installs the title, progress bar, and the design system's fixed back button onto
    /// `viewController`.
    ///
    /// - Parameter viewController: The screen to install this header on. Call this once,
    ///   from its `viewDidLoad`.
    func install(on viewController: UIViewController) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: NavigationHeaderMetrics.width).isActive = true
        viewController.navigationItem.titleView = titleLabel

        let backButton = UIBarButtonItem(
            image: UIImage(named: "backArrow"),
            primaryAction: UIAction { [weak viewController] _ in
                viewController?.navigationController?.popViewController(animated: true)
            }
        )
        backButton.tintColor = UIColor(DesignSystemColor.Text.primary)
        viewController.navigationItem.leftBarButtonItem = backButton

        viewController.view.addSubview(progressBarView)
        setUpProgressBarConstraints(in: viewController.view)
    }

    /// Pins `progressBarView` to the full width of `containerView`'s safe area, directly
    /// below the navigation bar, and stores the height constraint so `update` can collapse it
    /// to `0` when `progress` is `0`.
    ///
    /// - Parameter containerView: The screen's own view — must already be
    ///   `progressBarView`'s superview.
    private func setUpProgressBarConstraints(in containerView: UIView) {
        progressBarView.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = progressBarView.heightAnchor.constraint(
            equalToConstant: progressBarView.value > 0 ? NavigationProgressBarMetrics.height : 0
        )
        progressBarHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            progressBarView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            heightConstraint
        ])
    }
}
