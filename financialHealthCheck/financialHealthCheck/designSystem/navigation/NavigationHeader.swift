//
//  NavigationHeader.swift
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

/// Installs a screen's title and progress bar, and restyles the back button — the one place
/// that configures a custom header, so no screen wires up its own title view, progress bar,
/// or back button individually. Stateless: every function here acts directly on the
/// `UIViewController`/`UINavigationBar` passed in, with nothing to keep an instance around
/// for.
///
/// Usage: `NavigationHeader.install(title: "Income", progress: 2, on: self)`.
enum NavigationHeader {
    /// Installs `title` (as `viewController.navigationItem.titleView`) and a
    /// `NavigationProgressBarView` (pinned full-width to `viewController.view`'s safe area,
    /// directly below the navigation bar) onto `viewController`.
    ///
    /// - Parameters:
    ///   - title: The screen's title.
    ///   - progress: Forwarded to `NavigationProgressBarView`. `0` (the default) collapses the
    ///     progress bar's height to `0`, hiding it.
    ///   - viewController: The screen to install this header on. Call this once, from its
    ///     `viewDidLoad`.
    static func install(title: String, progress: Int = 0, on viewController: UIViewController) {
        let titleLabel = UILabel()
        titleLabel.setText(
            title,
            typography: Typography.Body.MD.medium,
            color: DesignSystemColor.Text.uiPrimary,
            alignment: .center
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: NavigationHeaderMetrics.width).isActive = true
        viewController.navigationItem.titleView = titleLabel

        let progressBarView = NavigationProgressBarView()
        progressBarView.value = progress
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(progressBarView)

        let safeArea = viewController.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            progressBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            progressBarView.heightAnchor.constraint(
                equalToConstant: progress > 0 ? NavigationProgressBarMetrics.height : 0
            )
        ])
    }

    /// Every screen gets the exact same back button (`backArrow`) — there's no per-screen
    /// customization for it, matching Figma, where the back button never changes. Styles the
    /// automatic back button directly on the shared `UINavigationBar`, rather than each screen
    /// setting its own `leftBarButtonItem`/`hidesBackButton`: those fight the navigation
    /// controller's own automatic back button during a push transition (it resets
    /// `hidesBackButton` back to `false` between `viewDidLoad` and `viewDidAppear`), causing
    /// both to render at once. Restyling the automatic back button itself sidesteps that race
    /// entirely, and it already pops on tap for free.
    ///
    /// - Parameter navigationController: Whose bar to style. `nil` (not yet in a navigation
    ///   stack) is a no-op.
    ///
    /// Usage: called from `NavigationHostingController.viewWillAppear` — every screen re-styles
    /// the same shared bar, which is harmless and keeps this out of a separate app-launch step.
    static func styleBackButton(on navigationController: UINavigationController?) {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.tintColor = DesignSystemColor.Text.uiPrimary
    }
}
