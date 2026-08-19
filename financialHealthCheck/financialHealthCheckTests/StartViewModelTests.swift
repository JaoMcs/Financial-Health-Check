//
//  StartViewModelTests.swift
//  financialHealthCheckTests
//
//  Created by Joao on 19/08/26.
//

import XCTest
@testable import financialHealthCheck

@MainActor
final class StartViewModelTests: XCTestCase {

    func testStartTapped_setsStateToLoadingImmediately() {
        let viewModel = StartViewModel(repository: MockHealthCheckRepository())

        viewModel.startTapped()

        XCTAssertEqual(viewModel.state, .loading)
    }

    func testStartSession_whenRepositorySucceeds_setsContentStateAndCallsOnStartTapped() async {
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion())
        let repository = MockHealthCheckRepository()
        repository.startSessionResult = .success(session)
        let viewModel = StartViewModel(repository: repository)

        var receivedSession: HealthCheckSessionDTO?
        viewModel.onStartTapped = { receivedSession = $0 }

        await viewModel.startSession()

        XCTAssertEqual(viewModel.state, .content)
        XCTAssertEqual(viewModel.session?.sessionId, session.sessionId)
        XCTAssertEqual(receivedSession?.sessionId, session.sessionId)
    }

    func testStartSession_whenRepositoryThrowsNetworkError_setsErrorStateAndDoesNotCallOnStartTapped() async {
        let repository = MockHealthCheckRepository()
        repository.startSessionResult = .failure(NetworkError.sessionNotFound)
        let viewModel = StartViewModel(repository: repository)

        var onStartTappedCalled = false
        viewModel.onStartTapped = { _ in onStartTappedCalled = true }

        await viewModel.startSession()

        XCTAssertEqual(viewModel.state, .error(.sessionNotFound))
        XCTAssertFalse(onStartTappedCalled)
    }

    func testStartSession_whenRepositoryThrowsNonNetworkError_fallsBackToUnrecognizedServerError() async {
        struct SomeOtherError: Error {}
        let repository = MockHealthCheckRepository()
        repository.startSessionResult = .failure(SomeOtherError())
        let viewModel = StartViewModel(repository: repository)

        await viewModel.startSession()

        XCTAssertEqual(viewModel.state, .error(.unrecognizedServerError(statusCode: 0, code: nil, message: nil)))
    }
}
