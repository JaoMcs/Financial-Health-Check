//
//  ResultCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI
import UIKit

/// Shows the flow's result screen (`ResultView`). Just that for now — score/title/description
/// are hardcoded until `ResultView` has a view model.
///
/// - Parameter navigationController: The stack this flow shows its screen on.
final class ResultCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let view = ResultView(
            score: 78,
            title: "Solid ground",
            description: "Good habits, small gains still available."
        )
        navigationController.setViewControllers([UIHostingController(rootView: view)], animated: false)
    }
}
