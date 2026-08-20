//
//  AppCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI
import UIKit

/// The app's root coordinator — owns the window and its navigation stack, shows the splash
/// screen, and starts whichever flow the resolved session state points to.
///
/// - Parameter window: The scene's window; `AppCoordinator` sets its `rootViewController` and
///   makes it key and visible.
final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var childCoordinators: [Coordinator] = []
    private let repository: HealthCheckRepositoring

    init(window: UIWindow) {
        self.window = window
        self.repository = HealthCheckRepository(networkManager: NetworkManager())
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let splashViewController = UIStoryboard(name: "LaunchScreen", bundle: nil)
            .instantiateInitialViewController() ?? UIViewController()
        navigationController.setViewControllers([splashViewController], animated: false)

        Task {
            await route()
        }
    }

    /// Resolves the destination and shows it, clearing the splash screen from
    /// `navigationController` first.
    private func route() async {
        if repository.hasExistingSession() {
            showRestoringSession()
        }

        let destination: SplashDestination
        do {
            destination = try await resolveDestination()
        } catch {
            destination = .start
        }

        // Just to avoid the back button during a runing session
        navigationController.setViewControllers([], animated: false)

        switch destination {
        case .start:
            let startCoordinator = StartCoordinator(
                navigationController: navigationController,
                repository: repository
            )
            childCoordinators.append(startCoordinator)
            startCoordinator.start()
        case .question(let session):
            let questionCoordinator = QuestionCoordinator(
                navigationController: navigationController,
                repository: repository,
                session: session
            )
            childCoordinators.append(questionCoordinator)
            questionCoordinator.start()
        case .result(let result):
            let resultCoordinator = ResultCoordinator(
                navigationController: navigationController,
                repository: repository,
                result: result
            )
            childCoordinators.append(resultCoordinator)
            resultCoordinator.start()
        }
    }

    /// Replaces the splash screen with `RestoringSessionView` while `resolveDestination()`
    /// asks the server where the persisted session left off.
    private func showRestoringSession() {
        let restoringViewController = UIHostingController(rootView: RestoringSessionView())
        navigationController.setViewControllers([restoringViewController], animated: true)
    }

    private func resolveDestination() async throws -> SplashDestination {
        guard repository.hasExistingSession() else { return .start }

        let session = try await repository.startSession()

        if session.status == Strings.SessionStatus.completed,
            let result = session.result {
            return .result(result)
        } else if session.status == Strings.SessionStatus.inProgress {
            return .question(session)
        } else {
            throw NetworkError.invalidResponse
        }
    }
}
