//
//  NavigationHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import UIKit

/// Layout values for `NavigationHeader`.
enum NavigationHeaderConstants {
    /// Width given to the title label once installed as a screen's `titleView`.
    static let width: CGFloat = 240
}

/// Installs a screen's title and progress bar, and restyles the back button. Stateless: every
/// function here acts directly on the `UIViewController`/`UINavigationBar` passed in.
enum NavigationHeader {
    /// Installs `title` and a `NavigationProgressBarView` onto `viewController`.
    ///
    /// - Parameters:
    ///   - title: The screen's title.
    ///   - current: Forwarded to `NavigationProgressBarView.setProgress(current:total:)`.
    ///   - total: Forwarded to `NavigationProgressBarView.setProgress(current:total:)`. `0`
    ///     (the default) hides the progress bar.
    ///   - viewController: The screen to install this header on.
    static func install(title: String, current: Int = 0, total: Int = 0, on viewController: UIViewController) {
        let titleLabel = UILabel()
        titleLabel.setText(
            title,
            typography: Typography.Body.MD.medium,
            color: DesignSystemColor.Text.uiPrimary,
            alignment: .center
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: NavigationHeaderConstants.width).isActive = true
        viewController.navigationItem.titleView = titleLabel

        let progressBarView = NavigationProgressBarView()
        progressBarView.setProgress(current: current, total: total)
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(progressBarView)

        let safeArea = viewController.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            progressBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            progressBarView.heightAnchor.constraint(
                equalToConstant: total > 0 ? NavigationProgressBarConstants.height : 0
            )
        ])
    }

    /// Restyles the automatic back button on the shared `UINavigationBar` to match Figma.
    ///
    /// - Parameter navigationController: Whose bar to style. `nil` is a no-op.
    static func styleBackButton(on navigationController: UINavigationController?) {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.tintColor = DesignSystemColor.Text.uiPrimary
    }
}
