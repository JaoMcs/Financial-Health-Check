//
//  QuestionaryViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Combine
import Foundation

/// `QuestionaryView`'s view model.
@MainActor
final class QuestionaryViewModel: ObservableObject {
    private let repository: HealthCheckRepositoring
    private let session: HealthCheckSessionDTO?

    /// The selected option's title, for `.singleChoice`. Bound to `RadioButtonList`, which
    /// tracks selection by title rather than id.
    @Published var singleSelection: String?
    /// The selected options' titles, for `.multipleChoice`. Bound to `CheckboxList`, same
    /// title-based tracking as `singleSelection`.
    @Published var multipleSelections: [String] = []
    /// The entered value, for `.number`. Bound to `AppTextField`.
    @Published var numberText = ""

    /// Drives which of `QuestionaryView`'s content/`ErrorView` is shown.
    @Published var state: ViewState = .content

    /// The session `submitAnswer()` resolved, once it returns.
    @Published private(set) var nextSession: HealthCheckSessionDTO?

    /// Called when the user taps "Continue", with the session `submitAnswer()` resolved. Set
    /// by `QuestionCoordinator` — empty for now.
    var onContinueTapped: ((HealthCheckSessionDTO?) -> Void) = { _ in }

    var onResultTapped: ((ResultDTO?) -> Void) = { _ in }

    var title: String {
        session?.question?.title ?? ""
    }

    var description: String {
        session?.question?.description ?? ""
    }

    init(repository: HealthCheckRepositoring, session: HealthCheckSessionDTO?) {
        self.repository = repository
        self.session = session
    }

    /// `question.type`/`options` mapped to the shape `QuestionaryView` renders.
    var content: QuestionaryContent {
        let options = (session?.question?.options ?? []).compactMap(\.title)
        switch session?.question?.type {
        case .singleChoice:
            return .singleChoice(options: options)
        case .multipleChoice:
            return .multipleChoice(options: options)
        case .number, nil:
            return .number
        }
    }

    /// Whether the user has selected/entered something to submit — the "Continue" button is
    /// disabled while this is `false`.
    var isAnswerSelected: Bool {
        !singleSelection.isNilOrEmpty || !multipleSelections.isEmpty || !numberText.isEmpty
    }

    /// The number field's helper text — always shown, stating its allowed range.
    /// `isNumberInvalid` is what colors it (and the field's border) as an error.
    var numberRangeMessage: String {
        Strings.Question.numberRangeMessage(
            min: session?.question?.validation?.min ?? 0,
            max: session?.question?.validation?.max ?? 0
        )
    }

    /// Whether `numberText` is non-empty but isn't a number within
    /// `validation.min`/`max` — `min`/`max` themselves are allowed values.
    var isNumberInvalid: Bool {
        guard !numberText.isEmpty else { return false }
        guard let value = numberValue else { return true }

        let min = Double(session?.question?.validation?.min ?? 0)
        let max = Double(session?.question?.validation?.max ?? 0)
        return value < min || value > max
    }

    /// `numberText` parsed as a `Double`, accepting `,` as well as `.` for the decimal
    /// separator — `.decimalPad`'s separator key inserts whatever the device's locale uses
    /// (`,` in pt-BR), which `Double.init?(String:)` only recognizes as `.`, regardless of
    /// locale.
    private var numberValue: Double? {
        Double(numberText.replacingOccurrences(of: ",", with: "."))
    }

    /// Whether `multipleSelections` is non-empty but its count falls outside
    /// `validation.minSelections`/`maxSelections`.
    var isMultipleSelectionInvalid: Bool {
        guard !multipleSelections.isEmpty else { return false }

        let count = multipleSelections.count
        if let min = session?.question?.validation?.minSelections, count < min {
            return true
        }
        if let max = session?.question?.validation?.maxSelections, count > max {
            return true
        }
        return false
    }

    /// Whether "Continue" should be disabled: a request is already in flight, nothing's been
    /// selected/entered yet, or the current selection fails its question's own validation.
    var isContinueDisabled: Bool {
        state.isLoading || !isAnswerSelected || isNumberInvalid || isMultipleSelectionInvalid
    }

    /// Applies `newSelections` from `CheckboxList`, ignoring it if it would check an option
    /// past `validation.maxSelections` — unlike `minSelections`, which can only be enforced
    /// once the user tries to continue, a maximum can be enforced right at selection time.
    ///
    /// - Parameter newSelections: The full selection set `CheckboxList` just produced.
    func updateMultipleSelections(_ newSelections: Set<String>) {
        if let max = session?.question?.validation?.maxSelections,
           newSelections.count > multipleSelections.count,
           newSelections.count > max {
            return
        }
        multipleSelections = Array(newSelections)
    }

    func continueTapped() {
        state = .loading
        Task {
            await submitAnswer()
        }
    }

    func submitAnswer() async {
        guard let answer = makeAnswer() else { return }

        do {
            let request = SubmitAnswerRequestDTO(questionId: session?.question?.id, answer: answer)
            nextSession = try await repository.submitAnswer(request)
            state = .content
            if nextSession?.status == Strings.SessionStatus.completed {
                onResultTapped(nextSession?.result)
            } else {
                onContinueTapped(nextSession)
            }
        } catch {
            state = .error(error as? NetworkError ?? .unrecognizedServerError(statusCode: 0, code: nil, message: nil))
        }
    }

    /// Maps the user's current selection to the shape the API expects — `nil` if nothing's
    /// been selected/entered yet.
    func makeAnswer() -> AnswerValue? {
        if let optionId = optionId(forTitle: singleSelection) {
            return .text(optionId)
        } else if !multipleSelections.isEmpty {
            let optionIds = multipleSelections.compactMap { optionId(forTitle: $0) }
            return optionIds.isEmpty ? nil : .choices(optionIds)
        } else if let number = numberValue {
            return .number(number)
        }
        return nil
    }

    /// Maps a `RadioButtonList`/`CheckboxList` option's displayed title back to its `id`.
    ///
    /// - Parameter title: The selected option's title.
    private func optionId(forTitle title: String?) -> String? {
        session?.question?.options?.first { $0.title == title }?.id
    }
}
