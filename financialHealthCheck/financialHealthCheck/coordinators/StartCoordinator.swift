//
//  StartCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI
import UIKit

/// Shows the flow's intro screen (`StartView`). Just that for now — nothing to hand off to
/// yet.
///
/// - Parameter navigationController: The stack this flow shows its screen on.
final class StartCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = StartViewModel()
        configure(viewModel)

        let view = StartView(viewModel: viewModel)
        navigationController.setViewControllers([UIHostingController(rootView: view)], animated: false)
    }

    /// Sets `viewModel`'s closures to this coordinator's own navigation — empty for now.
    ///
    /// - Parameter viewModel: The view model to configure.
    private func configure(_ viewModel: StartViewModel) {
        viewModel.onStartTapped = { [weak self] in
            self?.gotToQuestionView()
        }
    }

    private func gotToQuestionView() {
        let questionCoordinator = QuestionCoordinator(navigationController: navigationController)
        childCoordinators.append(questionCoordinator)
        questionCoordinator.start()
    }
}
