//
//  ResultViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Combine

/// `ResultView`'s view model. Holds the `ResultDTO` the last `submitAnswer()` call resolved.
@MainActor
final class ResultViewModel: ObservableObject {
    // MARK: - Dependencies
    private let repository: HealthCheckRepositoring
    private let result: ResultDTO?

    /// Drives which of `ResultView`'s content/`ErrorView` is shown. Always `.content` today.
    @Published var state: ViewState = .content

    /// Called when the user taps "Finish". Set by `ResultCoordinator` — empty for now.
    var onFinishTapped: (() -> Void) = { }
    /// Called when the user taps "Retake", after the session has already been deleted.
    var onRetakeTapped: (() -> Void) = { }

    init(repository: HealthCheckRepositoring, result: ResultDTO?) {
        self.repository = repository
        self.result = result
    }

    var score: Int {
        result?.score ?? 0
    }

    var title: String {
        Strings.Result.title(for: result?.category)
    }

    var description: String {
        Strings.Result.description(for: result?.category)
    }

    func finish() {
        // IDK WHAT TODO
        onFinishTapped()
    }

    func retake() {
        repository.deleteSession()
        onRetakeTapped()

    }
}
