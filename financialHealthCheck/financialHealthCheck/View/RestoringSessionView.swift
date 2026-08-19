//
//  RestoringSessionView.swift
//  financialHealthCheck
//
//  Created by Joao on 19/08/26.
//

import SwiftUI

/// Shown right after the splash screen when a persisted session id is found, while
/// `AppCoordinator` asks the server where that session left off — see
/// `AppCoordinator.route()`. Same visual language as `ErrorView` (an icon-in-circle plus a
/// `ScreenHeader`), but with a `ProgressView` centered over `Icon.iconBackground` instead of a
/// static icon, and no button — there's no action for the user to take while this is on
/// screen.
struct RestoringSessionView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                ZStack {
                    Icon.iconBackground
                    ProgressView()
                        .tint(DesignSystemColor.BackgroundAndSurface.surface)
                }
                .padding(.bottom, Spacing.threeXl)

                ScreenHeader(
                    caption: nil,
                    title: Strings.RestoringSession.title,
                    description: Strings.RestoringSession.description
                )
                .padding()
            }

            Spacer()
        }
    }
}

#Preview {
    RestoringSessionView()
}
