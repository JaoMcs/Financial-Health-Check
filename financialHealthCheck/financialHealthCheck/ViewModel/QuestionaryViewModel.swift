//
//  QuestionaryViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Combine

/// `QuestionaryView`'s view model. Static/mocked for now — `question` is hardcoded instead of
/// coming from `HealthCheckRepository`.
final class QuestionaryViewModel: ObservableObject {
    private let question = QuestionDTO(
        id: "income_stability",
        title: "How predictable is your income?",
        description: nil,
        type: .singleChoice,
        options: [
            QuestionOptionDTO(id: "very_stable", title: "Very predictable"),
            QuestionOptionDTO(id: "mostly_stable", title: "Mostly predictable"),
            QuestionOptionDTO(id: "variable", title: "It varies significantly"),
            QuestionOptionDTO(id: "unpredictable", title: "Very unpredictable")
        ],
        validation: QuestionValidationDTO(required: true, min: nil, max: nil, minSelections: nil, maxSelections: nil)
    )

    /// Called when the user taps "Continue". Set by `QuestionCoordinator` — empty for now.
    var onContinueTapped: (() -> Void)?

    var title: String {
        question.title ?? ""
    }

    var description: String {
        question.description ?? ""
    }

    /// `question.type`/`options` mapped to the shape `QuestionaryView` renders.
    var content: QuestionaryContent {
        let options = (question.options ?? []).compactMap(\.title)
        switch question.type {
        case .singleChoice:
            return .singleChoice(options: options)
        case .multipleChoice:
            return .multipleChoice(options: options)
        case .number, nil:
            return .number
        }
    }

    func continueTapped() {
        onContinueTapped?()
    }
}
