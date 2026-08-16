//
//  AppCoordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import UIKit

/// Where `AppCoordinator` routes to once it's resolved the current session state.
enum SplashDestination {
    /// No persisted session yet — the flow's very first screen.
    case start
    /// A persisted session, still in progress, resuming on this question.
    case question(QuestionDTO, ProgressDTO)
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

    /// Resolves the destination and shows it. `.question`/`.result` still show the same
    /// placeholder — `QuestionCoordinator`/`ResultCoordinator` aren't built yet — but each is
    /// routed independently so this doesn't need to change once they are.
    private func route() async {
        let destination: SplashDestination
        do {
            destination = try await resolveDestination()
        } catch {
            destination = .start
        }

        switch destination {
        case .start:
            let startCoordinator = StartCoordinator(navigationController: navigationController)
            childCoordinators.append(startCoordinator)
            startCoordinator.start()
        case .question:
            let questionCoordinator = QuestionCoordinator(navigationController: navigationController)
            childCoordinators.append(questionCoordinator)
            questionCoordinator.start()
        case .result:
            let resultCoordinator = ResultCoordinator(navigationController: navigationController)
            childCoordinators.append(resultCoordinator)
            resultCoordinator.start()
        }
    }

    private func resolveDestination() async throws -> SplashDestination {
        guard repository.hasExistingSession() else { return .start }

        let session = try await repository.startSession()

        if session.status == "completed",
           let result = session.result {
            return .result(result)
        } else if session.status == "in_progress",
                  let question = session.question,
                  let progress = session.progress {
            return .question(question, progress)
        } else {
            throw NetworkError.invalidResponse
        }
    }
}
