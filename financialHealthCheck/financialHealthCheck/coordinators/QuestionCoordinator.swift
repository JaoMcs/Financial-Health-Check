//
//  QuestionCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI
import UIKit

/// Shows the current question (`QuestionaryView`), with its `NavigationHeader` (title +
/// progress bar) installed via `NavigationHostingController`. Simplified for now — no
/// repository, no wiring to whatever comes next; title and progress are both hardcoded.
///
/// - Parameter navigationController: The stack this flow shows its screen on.
final class QuestionCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = QuestionaryViewModel()
        let view = QuestionaryView(viewModel: viewModel)
        let hostingController = NavigationHostingController(
            rootView: view,
            title: Strings.Question.navigationTitle,
            progress: 1
        )
        navigationController.pushViewController(hostingController, animated: true)
    }
}
