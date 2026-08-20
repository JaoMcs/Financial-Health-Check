//
//  ResultView.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// The flow's result screen: an `ImageHeader` showing `score` via `ScoreDisplay`, and a
/// `ButtonDock` pinned to the bottom edge.
struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel

    var body: some View {
        switch viewModel.state {
        case .loading, .content:
            contentView
        case .error(let error):
            ErrorView(error: error, action: {})
        }
    }

    private var contentView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ImageHeader(
                    media: .score(value: viewModel.score, maxScore: Strings.Result.maxScore),
                    title: viewModel.title,
                    description: viewModel.description
                )
                .frame(height: geometry.size.height / 2)

                Spacer()

                ButtonDock(
                    primaryText: Strings.Result.primaryButtonTitle,
                    secondaryText: Strings.Result.secondaryButtonTitle,
                    primaryAction: {},
                    secondaryAction: { viewModel.retake()},
                    secondaryLeadingIcon: Icon.arrowReturn
                )
                .padding(.top, Spacing.lg)
            }
        }
    }
}

#Preview {
    let repository = HealthCheckRepository(networkManager: NetworkManager())
    ResultView(viewModel: ResultViewModel(repository: repository, result: nil))
}
