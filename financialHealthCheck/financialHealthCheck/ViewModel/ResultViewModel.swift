//
//  ResultViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Combine

/// `ResultView`'s view model. Holds the `ResultDTO` the last `submitAnswer()` call resolved —
/// this screen makes no request of its own (see `NETWORKING.md`).
@MainActor
final class ResultViewModel: ObservableObject {
    private let repository: HealthCheckRepositoring
    private let result: ResultDTO?

    /// Drives which of `ResultView`'s content/`ErrorView` is shown. Always `.content` today —
    /// this screen makes no request of its own to fail — kept for the same shape as
    /// `StartViewModel`/`QuestionaryViewModel` in case that changes.
    @Published var state: ViewState = .content

    var onFinishTapped: (() -> Void) = { }

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
