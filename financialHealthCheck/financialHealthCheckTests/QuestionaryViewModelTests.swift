//
//  QuestionaryViewModelTests.swift
//  financialHealthCheckTests
//
//  Created by Joao on 19/08/26.
//

import XCTest
@testable import financialHealthCheck

@MainActor
final class QuestionaryViewModelTests: XCTestCase {

    // MARK: - title / description

    func testTitle_whenQuestionPresent_returnsQuestionTitle() {
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(title: "How are you?"))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertEqual(viewModel.title, "How are you?")
    }

    func testTitle_whenSessionIsNil_returnsEmptyString() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)

        XCTAssertEqual(viewModel.title, "")
    }

    func testDescription_whenQuestionHasDescription_returnsIt() {
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(description: "Pick one"))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertEqual(viewModel.description, "Pick one")
    }

    func testDescription_whenQuestionHasNoDescription_returnsEmptyString() {
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(description: nil))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertEqual(viewModel.description, "")
    }

    // MARK: - content

    func testContent_whenSingleChoice_returnsSingleChoiceWithOptionTitles() {
        let options = [Fixtures.option(id: "a", title: "A"), Fixtures.option(id: "b", title: "B")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        guard case .singleChoice(let titles) = viewModel.content else {
            return XCTFail("Expected .singleChoice")
        }
        XCTAssertEqual(titles, ["A", "B"])
    }

    func testContent_whenMultipleChoice_returnsMultipleChoiceWithOptionTitles() {
        let options = [Fixtures.option(id: "a", title: "A"), Fixtures.option(id: "b", title: "B")]
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        guard case .multipleChoice(let titles) = viewModel.content else {
            return XCTFail("Expected .multipleChoice")
        }
        XCTAssertEqual(titles, ["A", "B"])
    }

    func testContent_whenNumber_returnsNumber() {
        let session = Fixtures.session(question: Fixtures.numberQuestion())
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        guard case .number = viewModel.content else {
            return XCTFail("Expected .number")
        }
    }

    func testContent_whenQuestionTypeIsNil_fallsBackToNumber() {
        let question = QuestionDTO(id: "q", title: "T", type: nil)
        let session = Fixtures.session(question: question)
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        guard case .number = viewModel.content else {
            return XCTFail("Expected .number fallback")
        }
    }

    // MARK: - isAnswerSelected

    func testIsAnswerSelected_whenNothingSelected_returnsFalse() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)

        XCTAssertFalse(viewModel.isAnswerSelected)
    }

    func testIsAnswerSelected_whenSingleSelectionSet_returnsTrue() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)
        viewModel.singleSelection = "A"

        XCTAssertTrue(viewModel.isAnswerSelected)
    }

    func testIsAnswerSelected_whenMultipleSelectionsNonEmpty_returnsTrue() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)
        viewModel.multipleSelections = ["A"]

        XCTAssertTrue(viewModel.isAnswerSelected)
    }

    func testIsAnswerSelected_whenNumberTextNonEmpty_returnsTrue() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)
        viewModel.numberText = "10"

        XCTAssertTrue(viewModel.isAnswerSelected)
    }

    // MARK: - numberRangeMessage

    func testNumberRangeMessage_formatsMinAndMax() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 5, max: 50))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertEqual(viewModel.numberRangeMessage, "Enter a number between 5 and 50.")
    }

    func testNumberRangeMessage_whenValidationMissing_defaultsBoundsToZero() {
        let session = Fixtures.session(question: Fixtures.numberQuestion())
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertEqual(viewModel.numberRangeMessage, "Enter a number between 0 and 0.")
    }

    // MARK: - isNumberInvalid

    func testIsNumberInvalid_whenTextIsEmpty_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenTextIsNotANumber_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "abc"

        XCTAssertTrue(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueEqualsMin_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "0"

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueEqualsMax_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "10"

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueIsBelowMin_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "-1"

        XCTAssertTrue(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueIsAboveMax_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "11"

        XCTAssertTrue(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueIsStrictlyWithinRange_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "5"

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueIsDecimalWithinRange_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "5.5"

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueIsDecimalAboveMax_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "10.5"

        XCTAssertTrue(viewModel.isNumberInvalid)
    }

    func testIsNumberInvalid_whenValueUsesCommaAsDecimalSeparator_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.numberQuestion(min: 0, max: 10))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.numberText = "5,5"

        XCTAssertFalse(viewModel.isNumberInvalid)
    }

    // MARK: - isMultipleSelectionInvalid

    func testIsMultipleSelectionInvalid_whenEmpty_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(minSelections: 2, maxSelections: 3))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        XCTAssertFalse(viewModel.isMultipleSelectionInvalid)
    }

    func testIsMultipleSelectionInvalid_whenBelowMin_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(minSelections: 2, maxSelections: 3))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A"]

        XCTAssertTrue(viewModel.isMultipleSelectionInvalid)
    }

    func testIsMultipleSelectionInvalid_whenAboveMax_returnsTrue() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(minSelections: 1, maxSelections: 2))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A", "B", "C"]

        XCTAssertTrue(viewModel.isMultipleSelectionInvalid)
    }

    func testIsMultipleSelectionInvalid_whenWithinBounds_returnsFalse() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(minSelections: 1, maxSelections: 3))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A", "B"]

        XCTAssertFalse(viewModel.isMultipleSelectionInvalid)
    }

    func testIsMultipleSelectionInvalid_whenNoBoundsSet_alwaysReturnsFalse() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(minSelections: nil, maxSelections: nil))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A", "B", "C", "D"]

        XCTAssertFalse(viewModel.isMultipleSelectionInvalid)
    }

    // MARK: - updateMultipleSelections

    func testUpdateMultipleSelections_whenWithinMax_applies() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(maxSelections: 2))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        viewModel.updateMultipleSelections(["A"])

        XCTAssertEqual(viewModel.multipleSelections, ["A"])
    }

    func testUpdateMultipleSelections_whenExceedingMax_isIgnored() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(maxSelections: 1))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.updateMultipleSelections(["A"])

        viewModel.updateMultipleSelections(["A", "B"])

        XCTAssertEqual(viewModel.multipleSelections, ["A"])
    }

    func testUpdateMultipleSelections_whenRemovingWhileAtMax_isApplied() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(maxSelections: 1))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.updateMultipleSelections(["A"])

        viewModel.updateMultipleSelections([])

        XCTAssertEqual(viewModel.multipleSelections, [])
    }

    func testUpdateMultipleSelections_whenNoMaxSet_alwaysApplies() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(maxSelections: nil))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)

        viewModel.updateMultipleSelections(["A", "B", "C"])

        XCTAssertEqual(Set(viewModel.multipleSelections), Set(["A", "B", "C"]))
    }

    // MARK: - makeAnswer

    func testMakeAnswer_whenSingleSelectionSet_returnsTextWithOptionId() {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.singleSelection = "A"

        XCTAssertEqual(viewModel.makeAnswer(), .text("opt-a"))
    }

    func testMakeAnswer_whenMultipleSelectionsSet_returnsChoicesWithOptionIds() {
        let options = [Fixtures.option(id: "opt-a", title: "A"), Fixtures.option(id: "opt-b", title: "B")]
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A", "B"]

        XCTAssertEqual(viewModel.makeAnswer(), .choices(["opt-a", "opt-b"]))
    }

    func testMakeAnswer_whenMultipleSelectionsMatchNoOption_returnsNil() {
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(options: []))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["Unknown"]

        XCTAssertNil(viewModel.makeAnswer())
    }

    func testMakeAnswer_whenNumberTextSet_returnsNumber() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)
        viewModel.numberText = "42"

        XCTAssertEqual(viewModel.makeAnswer(), .number(42))
    }

    func testMakeAnswer_whenNumberTextUsesCommaAsDecimalSeparator_returnsNumberWithPeriod() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)
        viewModel.numberText = "5,5"

        XCTAssertEqual(viewModel.makeAnswer(), .number(5.5))
    }

    func testMakeAnswer_whenNothingSelected_returnsNil() {
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: nil)

        XCTAssertNil(viewModel.makeAnswer())
    }

    func testMakeAnswer_prefersSingleSelectionOverMultipleAndNumber() {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.singleSelection = "A"
        viewModel.multipleSelections = ["B"]
        viewModel.numberText = "10"

        XCTAssertEqual(viewModel.makeAnswer(), .text("opt-a"))
    }

    func testMakeAnswer_prefersMultipleSelectionsOverNumber() {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.multipleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.multipleSelections = ["A"]
        viewModel.numberText = "10"

        XCTAssertEqual(viewModel.makeAnswer(), .choices(["opt-a"]))
    }

    // MARK: - submitAnswer / continueTapped

    func testSubmitAnswer_whenNothingSelected_doesNotCallRepository() async {
        let repository = MockHealthCheckRepository()
        let viewModel = QuestionaryViewModel(repository: repository, session: nil)

        await viewModel.submitAnswer()

        XCTAssertNil(repository.submitAnswerRequest)
        XCTAssertEqual(viewModel.state, .content)
    }

    func testSubmitAnswer_sendsCurrentQuestionIdAndAnswer() async {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(id: "q1", options: options))
        let repository = MockHealthCheckRepository()
        repository.submitAnswerResult = .success(Fixtures.session())
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        viewModel.singleSelection = "A"

        await viewModel.submitAnswer()

        XCTAssertEqual(repository.submitAnswerRequest?.questionId, "q1")
        XCTAssertEqual(repository.submitAnswerRequest?.answer, .text("opt-a"))
    }

    func testSubmitAnswer_whenSessionCompletes_callsOnResultTappedNotOnContinueTapped() async {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let result = ResultDTO(score: 80, category: .good)
        let repository = MockHealthCheckRepository()
        repository.submitAnswerResult = .success(Fixtures.session(status: "completed", result: result))
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        viewModel.singleSelection = "A"

        var receivedResult: ResultDTO?
        var onContinueTappedCalled = false
        viewModel.onResultTapped = { receivedResult = $0 }
        viewModel.onContinueTapped = { _ in onContinueTappedCalled = true }

        await viewModel.submitAnswer()

        XCTAssertEqual(receivedResult?.score, 80)
        XCTAssertFalse(onContinueTappedCalled)
        XCTAssertEqual(viewModel.state, .content)
    }

    func testSubmitAnswer_whenSessionContinues_callsOnContinueTappedNotOnResultTapped() async {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let nextQuestion = Fixtures.numberQuestion(id: "q2")
        let repository = MockHealthCheckRepository()
        repository.submitAnswerResult = .success(Fixtures.session(status: "in_progress", question: nextQuestion))
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        viewModel.singleSelection = "A"

        var receivedSession: HealthCheckSessionDTO?
        var onResultTappedCalled = false
        viewModel.onContinueTapped = { receivedSession = $0 }
        viewModel.onResultTapped = { _ in onResultTappedCalled = true }

        await viewModel.submitAnswer()

        XCTAssertEqual(receivedSession?.question?.id, "q2")
        XCTAssertFalse(onResultTappedCalled)
    }

    func testSubmitAnswer_whenRepositoryThrowsNetworkError_setsErrorState() async {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let repository = MockHealthCheckRepository()
        repository.submitAnswerResult = .failure(NetworkError.validationError(field: "answer", message: "Invalid"))
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        viewModel.singleSelection = "A"

        await viewModel.submitAnswer()

        XCTAssertEqual(viewModel.state, .error(.validationError(field: "answer", message: "Invalid")))
    }

    func testSubmitAnswer_whenRepositoryThrowsNonNetworkError_fallsBackToUnrecognizedServerError() async {
        struct SomeOtherError: Error {}
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let repository = MockHealthCheckRepository()
        repository.submitAnswerResult = .failure(SomeOtherError())
        let viewModel = QuestionaryViewModel(repository: repository, session: session)
        viewModel.singleSelection = "A"

        await viewModel.submitAnswer()

        XCTAssertEqual(viewModel.state, .error(.unrecognizedServerError(statusCode: 0, code: nil, message: nil)))
    }

    func testContinueTapped_setsStateToLoadingImmediately() {
        let options = [Fixtures.option(id: "opt-a", title: "A")]
        let session = Fixtures.session(question: Fixtures.singleChoiceQuestion(options: options))
        let viewModel = QuestionaryViewModel(repository: MockHealthCheckRepository(), session: session)
        viewModel.singleSelection = "A"

        viewModel.continueTapped()

        XCTAssertEqual(viewModel.state, .loading)
    }
}
