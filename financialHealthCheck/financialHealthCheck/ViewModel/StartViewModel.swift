//
//  StartViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Combine

/// `StartView`'s view model.
@MainActor
final class StartViewModel: ObservableObject {
    // MARK: - Dependence
    private let repository: HealthCheckRepositoring

    @Published var session: HealthCheckSessionDTO?

    /// Drives which of `StartView`'s content/`ErrorView` is shown.
    @Published var state: ViewState = .content

    /// Called when the user taps "Start", with the resolved session.
    var onStartTapped: ((HealthCheckSessionDTO?) -> Void) = { _ in }

    init(repository: HealthCheckRepositoring) {
        self.repository = repository
    }

    func startTapped() {
        state = .loading
        Task {
            await startSession()
        }
    }

    func startSession() async {
        do {
            session = try await repository.startSession()
            state = .content
            onStartTapped(session)
        } catch {
            state = .error(error as? NetworkError ?? .unrecognizedServerError(statusCode: 0, code: nil, message: nil))
        }
    }
}
