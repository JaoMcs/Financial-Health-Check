//
//  ResultCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI
import UIKit

/// Shows the flow's result screen (`ResultView`).
///
/// - Parameters:
///   - navigationController: The stack this flow shows its screen on.
///   - repository: Passed down to `ResultViewModel`.
///   - result: The result the last `submitAnswer()` call resolved. Passed down to
///     `ResultViewModel`.
final class ResultCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let repository: HealthCheckRepositoring
    private let result: ResultDTO?
    private var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController,
         repository: HealthCheckRepositoring,
         result: ResultDTO?) {
        self.navigationController = navigationController
        self.repository = repository
        self.result = result
    }

    func start() {
        let viewModel = ResultViewModel(repository: repository, result: result)
        configure(viewModel)
        let view = ResultView(viewModel: viewModel)
        navigationController.setViewControllers([UIHostingController(rootView: view)],
                                                animated: true)
    }

    /// Sets `viewModel`'s closures to this coordinator's own navigation.
    ///
    /// - Parameter viewModel: The view model to configure.
    private func configure(_ viewModel: ResultViewModel) {
        viewModel.onFinishTapped = { [weak self] in
            self?.goToFinish()
        }
        viewModel.onRetakeTapped = { [weak self] in
            self?.goToStart()
        }
    }

    private func goToStart() {
        let startCoordinator = StartCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        childCoordinators.append(startCoordinator)
        startCoordinator.start()
    }

    private func goToFinish() {
        print("Finish uhull :pray-cat:")
    }

}
