//
//  RestoringSessionView.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// Shown right after splash while `AppCoordinator` resumes a persisted session — a
/// `ProgressView` over `Icon.iconBackground` plus a `ScreenHeader`, no button.
struct RestoringSessionView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: Spacing.threeXl) {
                ZStack {
                    Icon.iconBackground
                    ProgressView()
                        .tint(DesignSystemColor.BackgroundAndSurface.surface)
                }

                ScreenHeader(
                    caption: nil,
                    title: Strings.RestoringSession.title,
                    description: Strings.RestoringSession.description
                )
            }

            Spacer()
        }
    }
}

#Preview {
    RestoringSessionView()
}
