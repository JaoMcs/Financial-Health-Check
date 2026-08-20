//
//  QuestionaryView.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI

/// A question screen: a `ScreenHeader`, one of `QuestionaryContent`'s selection components,
/// and a "Continue" button pinned to the bottom edge.
struct QuestionaryView: View {
    @ObservedObject var viewModel: QuestionaryViewModel

    var body: some View {
        switch viewModel.state {
        case .loading, .content:
            contentView
        case .error(let error):
            let kind = ErrorViewKind(error)
            ErrorView(
                error: error,
                action: kind.requiresSessionReset ? viewModel.resetSession : viewModel.continueTapped
            )
        }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            ScreenHeader(
                caption: nil,
                title: viewModel.title,
                description: viewModel.description
            )
            .padding(.top, Spacing.twoXl)
            .padding(.bottom, Spacing.twoXl)

            selectionView
                .padding(.horizontal, Spacing.twoXl)

            Spacer()

            AppButton(
                text: Strings.Question.continueButtonTitle,
                type: .primary,
                isLoading: viewModel.state.isLoading,
                action: viewModel.continueTapped
            )
            .disabled(viewModel.isContinueDisabled)
            .padding(.horizontal, Spacing.twoXl)
        }
    }

    @ViewBuilder
    private var selectionView: some View {
        switch viewModel.content {
        case .singleChoice(let options):
            RadioButtonList(selection: $viewModel.singleSelection, options: options)
        case .multipleChoice(let options):
            CheckboxList(
                selections: Binding(
                    get: { Set(viewModel.multipleSelections) },
                    set: { viewModel.updateMultipleSelections($0) }
                ),
                options: options
            )
        case .number:
            AppTextField(
                text: $viewModel.numberText,
                placeholder: Strings.Question.numberPlaceholder,
                prefix: Strings.Question.numberPrefix,
                message: viewModel.numberRangeMessage,
                isError: viewModel.isNumberInvalid,
                keyboardType: .decimalPad
            )
        }
    }
}

#Preview {
    let repository = HealthCheckRepository(networkManager: NetworkManager())
    QuestionaryView(viewModel: QuestionaryViewModel(repository: repository, session: nil))
}
