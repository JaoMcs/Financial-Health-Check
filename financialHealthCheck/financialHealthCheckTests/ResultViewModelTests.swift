//
//  ResultViewModelTests.swift
//  financialHealthCheckTests
//
//  Created by Joao on 19/08/26.
//

import XCTest
@testable import financialHealthCheck

@MainActor
final class ResultViewModelTests: XCTestCase {

    private let allCategories: [ResultCategory] = [.excellent, .good, .fair, .poor]

    func testScore_whenResultPresent_returnsItsScore() {
        let viewModel = ResultViewModel(
            repository: MockHealthCheckRepository(),
            result: ResultDTO(score: 75, category: .fair)
        )

        XCTAssertEqual(viewModel.score, 75)
    }

    func testScore_whenResultIsNil_returnsZero() {
        let viewModel = ResultViewModel(repository: MockHealthCheckRepository(), result: nil)

        XCTAssertEqual(viewModel.score, 0)
    }

    func testTitle_matchesStringsForEveryCategory() {
        for category in allCategories {
            let viewModel = ResultViewModel(
                repository: MockHealthCheckRepository(),
                result: ResultDTO(category: category)
            )

            XCTAssertEqual(viewModel.title, Strings.Result.title(for: category))
        }
    }

    func testTitle_whenResultIsNil_matchesPoorCategory() {
        let viewModel = ResultViewModel(repository: MockHealthCheckRepository(), result: nil)

        XCTAssertEqual(viewModel.title, Strings.Result.title(for: .poor))
    }

    func testDescription_matchesStringsForEveryCategory() {
        for category in allCategories {
            let viewModel = ResultViewModel(
                repository: MockHealthCheckRepository(),
                result: ResultDTO(category: category)
            )

            XCTAssertEqual(viewModel.description, Strings.Result.description(for: category))
        }
    }

    func testDescription_whenResultIsNil_matchesPoorCategory() {
        let viewModel = ResultViewModel(repository: MockHealthCheckRepository(), result: nil)

        XCTAssertEqual(viewModel.description, Strings.Result.description(for: .poor))
    }

    func testFinish_callsOnFinishTapped() {
        let viewModel = ResultViewModel(repository: MockHealthCheckRepository(), result: nil)
        var called = false
        viewModel.onFinishTapped = { called = true }

        viewModel.finish()

        XCTAssertTrue(called)
    }

    func testRetake_deletesSessionAndCallsOnRetakeTapped() {
        let repository = MockHealthCheckRepository()
        let viewModel = ResultViewModel(repository: repository, result: nil)
        var called = false
        viewModel.onRetakeTapped = { called = true }

        viewModel.retake()

        XCTAssertEqual(repository.deleteSessionCallCount, 1)
        XCTAssertTrue(called)
    }
}
