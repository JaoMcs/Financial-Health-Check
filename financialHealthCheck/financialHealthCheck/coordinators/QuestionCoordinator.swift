//
//  QuestionCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI
import UIKit

/// Shows the current question (`QuestionaryView`), with its `NavigationHeader` (title +
/// progress bar) installed via `NavigationHostingController`.
///
/// - Parameters:
///   - navigationController: The stack this flow shows its screen on.
///   - repository: Passed down to `QuestionaryViewModel`.
///   - session: The session resolved by whichever screen led here (`nil` if none yet).
///     Passed down to `QuestionaryViewModel`.
final class QuestionCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let repository: HealthCheckRepositoring
    private let session: HealthCheckSessionDTO?
    private var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController,
         repository: HealthCheckRepositoring,
         session: HealthCheckSessionDTO?) {
        self.navigationController = navigationController
        self.repository = repository
        self.session = session
    }

    func start() {
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        configure(viewModel)

        let view = QuestionaryView(viewModel: viewModel)

        let current = session?.progress?.current ?? 1
        let total = session?.progress?.total ?? AppConfig.defaultQuestionCount
        let hostingController = NavigationHostingController(
            rootView: view,
            title: Strings.Question.navigationTitle(current: current, total: total),
            current: current,
            total: total
        )
        navigationController.pushViewController(hostingController, animated: true)
    }

    /// Sets `viewModel`'s closures to this coordinator's own navigation.
    ///
    /// - Parameter viewModel: The view model to configure.
    private func configure(_ viewModel: QuestionaryViewModel) {
        viewModel.onContinueTapped = { [weak self] session in
            self?.goToNextQuestion(session: session)
        }
        viewModel.onResultTapped = { [weak self] result in
            self?.goToResult(result: result)
        }
        viewModel.onSessionReset = { [weak self] in
            self?.goToStart()
        }
    }

    private func goToNextQuestion(session: HealthCheckSessionDTO?) {
        let questionCoordinator = QuestionCoordinator(
            navigationController: navigationController,
            repository: repository,
            session: session
        )
        childCoordinators.append(questionCoordinator)
        questionCoordinator.start()
    }

    /// Reached from `QuestionaryViewModel.resetSession()`, after the session was cleared.
    private func goToStart() {
        let startCoordinator = StartCoordinator(
            navigationController: navigationController,
            repository: repository
        )
        childCoordinators.append(startCoordinator)
        startCoordinator.start()
    }

    private func goToResult(result: ResultDTO?) {
        let resultCoordinator = ResultCoordinator(
            navigationController: navigationController,
            repository: repository,
            result: result
        )
        childCoordinators.append(resultCoordinator)
        resultCoordinator.start()
    }
}
