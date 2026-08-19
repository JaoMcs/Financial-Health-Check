//
//  MockHealthCheckRepository.swift
//  financialHealthCheckTests
//
//  Created by Joao on 19/08/26.
//

@testable import financialHealthCheck

/// Fake `HealthCheckRepositoring` for ViewModel tests — doubles as a stub (`Result` properties
/// control what each call returns/throws) and a spy (records what was passed in), which is
/// enough for this protocol's size without a mocking library.
final class MockHealthCheckRepository: HealthCheckRepositoring {
    var hasExistingSessionResult = false
    var startSessionResult: Result<HealthCheckSessionDTO, Error> = .failure(NetworkError.invalidResponse)
    var submitAnswerResult: Result<HealthCheckSessionDTO, Error> = .failure(NetworkError.invalidResponse)

    /// The last request `submitAnswer(_:)` was called with, `nil` if it hasn't been called.
    private(set) var submitAnswerRequest: SubmitAnswerRequestDTO?
    private(set) var deleteSessionCallCount = 0

    func hasExistingSession() -> Bool {
        hasExistingSessionResult
    }

    func startSession() async throws -> HealthCheckSessionDTO {
        try startSessionResult.get()
    }

    func submitAnswer(_ answer: SubmitAnswerRequestDTO) async throws -> HealthCheckSessionDTO {
        submitAnswerRequest = answer
        return try submitAnswerResult.get()
    }

    func deleteSession() {
        deleteSessionCallCount += 1
    }
}
