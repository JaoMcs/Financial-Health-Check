//
//  ResultView.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// The flow's result screen (Figma): an `ImageHeader` — showing `score` via `ScoreDisplay`
/// instead of an image — centered in the top half of the screen, an empty bottom half, and a
/// `ButtonDock` pinned to the bottom edge.
struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel

    var body: some View {
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
