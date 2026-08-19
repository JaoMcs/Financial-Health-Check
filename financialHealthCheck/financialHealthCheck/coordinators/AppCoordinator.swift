//
//  AppCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI
import UIKit

/// Where `AppCoordinator` routes to once it's resolved the current session state.
enum SplashDestination {
    /// No persisted session yet — the flow's very first screen.
    case start
    /// A persisted session, still in progress, resuming on this question.
    case question(HealthCheckSessionDTO)
    /// A persisted session that already reached its result.
    case result(ResultDTO)
}

/// The app's root coordinator — owns the window and its navigation stack, shows the splash
/// screen, and starts whichever flow the resolved session state points to.
///
/// There's no separate `SplashCoordinator`: the splash "screen" is `LaunchScreen.storyboard`'s
/// own view controller (already designed, no ViewModel, no user interaction), so resolving
/// where to go next is a plain step inside this coordinator's `start()` rather than a flow of
/// its own.
///
/// - Parameter window: The scene's window; `AppCoordinator` sets its `rootViewController` and
///   makes it key and visible.
///
/// Usage: created and started once, in `SceneDelegate.scene(_:willConnectTo:options:)`.
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

    /// Resolves the destination and shows it. Clears the splash from `navigationController`
    /// first — it's not a real screen, so whichever coordinator starts next shouldn't have it
    /// sitting underneath as a back target. Pushing onto an empty stack already behaves like
    /// setting a root (no back button), so this is enough on its own; no coordinator needs to
    /// know whether it's first.
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
    /// asks the server where the persisted session left off — called only when a session id
    /// is already there to resume, so this never shows for a first-time launch.
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
