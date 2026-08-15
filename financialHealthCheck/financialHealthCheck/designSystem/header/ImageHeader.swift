//
//  ImageHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// The design system's centered image header (Figma): a 200x200 image, a title, and a
/// description, stacked vertically and all center-aligned.
///
/// - **Image**: 200x200, 32pt below it.
/// - **Title**: `Heading/LG`, `Text.primary`, 8pt below it.
/// - **Description**: `Body/MD`, `Text.secondary`.
///
/// - Parameters:
///   - image: Shown at the top, resized to 200x200.
///   - title: The heading shown below `image`.
///   - description: Supporting copy shown below `title`.
///
/// Usage: `ImageHeader(image: Icon.mainImage, title: "...", description: "...")`.
struct ImageHeader: View {
    let image: Image
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.bottom, Spacing.threeXl)

            Text(title)
                .typography(Typography.Heading.lg)
                .foregroundStyle(DesignSystemColor.Text.primary)
                .multilineTextAlignment(.center)
                .padding(.bottom, Spacing.sm)

            Text(description)
                .typography(Typography.Body.MD.regular)
                .foregroundStyle(DesignSystemColor.Text.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    ImageHeader(
        image: Icon.mainImage,
        title: "How healthy are your finances?",
        description: "5 questions, 2 minutes."
    )
}
