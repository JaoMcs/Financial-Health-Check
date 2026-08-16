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
/// - Parameters:
///   - navigationController: The stack this flow shows its screen on.
///   - repository: Passed down to `StartViewModel`, and threaded into whatever this flow
///     hands off to next.
final class StartCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let repository: HealthCheckRepositoring
    private var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController, repository: HealthCheckRepositoring) {
        self.navigationController = navigationController
        self.repository = repository
    }

    func start() {
        let viewModel = StartViewModel(repository: repository)
        configure(viewModel)

        let view = StartView(viewModel: viewModel)
        navigationController.setViewControllers([UIHostingController(rootView: view)], animated: false)
    }

    /// Sets `viewModel`'s closures to this coordinator's own navigation — empty for now.
    ///
    /// - Parameter viewModel: The view model to configure.
    private func configure(_ viewModel: StartViewModel) {
        viewModel.onStartTapped = { [weak self] session in
            self?.gotToQuestionView(session: session)
        }
    }

    private func gotToQuestionView(session: HealthCheckSessionDTO?) {
        let questionCoordinator = QuestionCoordinator(
            navigationController: navigationController,
            repository: repository,
            session: session
        )
        childCoordinators.append(questionCoordinator)
        questionCoordinator.start()
    }
}
