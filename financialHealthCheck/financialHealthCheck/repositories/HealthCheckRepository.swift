//
//  HealthCheckRepository.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// Domain operations for the health-check questionnaire flow — the only thing ViewModels
/// depend on for data.
protocol HealthCheckRepositoring {
    /// Whether this device already has a persisted session, without making a network call.
    func hasExistingSession() -> Bool

    /// Starts a new session, or resumes an existing one wherever it left off.
    func startSession() async throws -> HealthCheckSessionDTO

    /// Submits `answer` to the session's current question.
    ///
    /// - Parameter answer: The question being answered, and its value.
    func submitAnswer(_ answer: SubmitAnswerRequestDTO) async throws -> HealthCheckSessionDTO

    /// Deletes the persisted session id, so the next `startSession()` starts a fresh one.
    func deleteSession()
}

/// Conforms to `HealthCheckRepositoring`. The only thing that talks to `KeychainManager`.
///
/// - Parameter networkManager: Sends this repository's requests to the API.
final class HealthCheckRepository: HealthCheckRepositoring {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func hasExistingSession() -> Bool {
        KeychainManager.load() != nil
    }

    /// Returns the persisted session id, generating and persisting a new one if none exists yet.
    private func resolvedSessionId() -> String {
        if let sessionId = KeychainManager.load() {
            return sessionId
        }

        let sessionId = UUID().uuidString
        KeychainManager.save(sessionId)
        return sessionId
    }

    func startSession() async throws -> HealthCheckSessionDTO {
        let sessionId = resolvedSessionId()
        return try await networkManager.request(
            endpoint: Endpoint.urlBase + Endpoint.sessions + "/\(sessionId)",
            method: .post,
            parameters: nil
        )
    }

    func submitAnswer(_ answer: SubmitAnswerRequestDTO) async throws -> HealthCheckSessionDTO {
        let sessionId = resolvedSessionId()
        return try await networkManager.request(
            endpoint: Endpoint.urlBase + Endpoint.sessions + "/\(sessionId)" + Endpoint.submission,
            method: .post,
            parameters: answer
        )
    }

    func deleteSession() {
        KeychainManager.delete()
    }
}
