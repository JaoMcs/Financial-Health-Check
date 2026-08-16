//
//  StartViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Combine

/// `StartView`'s view model.
final class StartViewModel: ObservableObject {
    private let repository: HealthCheckRepositoring

    // TODO: - documentar dps
    @Published var session: HealthCheckSessionDTO?

    /// Called when the user taps "Start", with the session `startSession()` resolved. Set by
    /// `StartCoordinator` — empty for now.
    var onStartTapped: ((HealthCheckSessionDTO?) -> Void) = { _ in }

    init(repository: HealthCheckRepositoring) {
        self.repository = repository
    }

    func startTapped() {
        Task {
            await startSession()
            onStartTapped(session)
        }
    }

    func startSession() async {
        do {
            session = try await repository.startSession()
        } catch {
            // TODO: - Tratamento de erro
        }
    }
}
