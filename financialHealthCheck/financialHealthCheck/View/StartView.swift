//
//  StartView.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// The flow's intro screen (Figma): an `ImageHeader` centered in the top half of the screen,
/// an empty bottom half, and a "Start" button pinned to the bottom edge.
struct StartView: View {
    @ObservedObject var viewModel: StartViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ImageHeader(
                    media: .image(Icon.mainImage),
                    title: Strings.Start.title,
                    description: Strings.Start.description
                )
                .frame(height: geometry.size.height / 2)

                Spacer()

                AppButton(
                    text: Strings.Start.buttonTitle,
                    trailingIcon: Icon.rightArrowIcon,
                    type: .primary,
                    action: viewModel.startTapped
                )
                .padding(.leading, Spacing.twoXl)
                .padding(.trailing, Spacing.twoXl)
                .padding(.top, Spacing.lg)
            }
        }
    }
}

#Preview {
    StartView(viewModel: StartViewModel())
}
