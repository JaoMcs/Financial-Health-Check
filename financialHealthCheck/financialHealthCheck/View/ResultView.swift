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
    let score: Int
    let title: String
    let description: String

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ImageHeader(
                    media: .score(score),
                    title: title,
                    description: description
                )
                .frame(height: geometry.size.height / 2)

                Spacer()

                ButtonDock(
                    primaryText: Strings.Result.primaryButtonTitle,
                    secondaryText: Strings.Result.secondaryButtonTitle,
                    primaryAction: {},
                    secondaryAction: {},
                    secondaryLeadingIcon: Icon.arrowReturn
                )
                .padding(.top, Spacing.lg)
            }
        }
    }
}

#Preview {
    ResultView(score: 78, title: "Solid ground", description: "Good habits, small gains still available.")
}
