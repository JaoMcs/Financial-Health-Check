//
//  QuestionaryView.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI

/// Which selection component `QuestionaryView` renders below its header, mirroring
/// `QuestionType`.
enum QuestionaryContent {
    /// `.singleChoice` — a `RadioButtonList` over `options`.
    case singleChoice(options: [String])
    /// `.multipleChoice` — a `CheckboxList` over `options`.
    case multipleChoice(options: [String])
    /// `.number` — a single `AppTextField`.
    case number
}

/// A question screen: a `ScreenHeader`, one of `QuestionaryContent`'s selection components,
/// and a "Continue" button pinned to the bottom edge.
struct QuestionaryView: View {
    @ObservedObject var viewModel: QuestionaryViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(
                caption: nil,
                title: viewModel.title,
                description: viewModel.description
            )
            .padding(.top, Spacing.twoXl)
            .padding(.bottom, Spacing.twoXl)

            contentView
                .padding(.horizontal, Spacing.twoXl)

            Spacer()

            AppButton(
                text: Strings.Question.continueButtonTitle,
                type: .primary,
                action: viewModel.continueTapped
            )
            .disabled(!viewModel.isAnswerSelected)
            .padding(.horizontal, Spacing.twoXl)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.content {
        case .singleChoice(let options):
            RadioButtonList(selection: $viewModel.singleSelection, options: options)
        case .multipleChoice(let options):
            CheckboxList(
                selections: Binding(
                    get: { Set(viewModel.multipleSelections) },
                    set: { viewModel.multipleSelections = Array($0) }
                ),
                options: options
            )
        case .number:
            AppTextField(
                text: $viewModel.numberText,
                placeholder: Strings.Question.numberPlaceholder,
                prefix: Strings.Question.numberPrefix,
                message: viewModel.numberRangeMessage,
                isError: viewModel.isNumberInvalid
            )
        }
    }
}

#Preview {
    let repository = HealthCheckRepository(networkManager: NetworkManager())
    QuestionaryView(viewModel: QuestionaryViewModel(repository: repository, session: nil))
}
