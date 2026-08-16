//
//  ImageHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// What `ImageHeader` shows above its title/description.
enum ImageHeaderMedia {
    /// A 200x200 image.
    case image(Image)
    /// A `ScoreDisplay` (240x240), showing `value` out of `maxScore`.
    case score(value: Int, maxScore: Int)
}

/// The design system's centered image header (Figma): `media`, a title, and a description,
/// stacked vertically and all center-aligned.
///
/// - **Media**: 200x200 (`.image`) or 240x240 (`.score`), 32pt below it.
/// - **Title**: `Heading/LG`, `Text.primary`, 8pt below it.
/// - **Description**: `Body/MD`, `Text.secondary`.
///
/// - Parameters:
///   - media: Shown at the top — either a fixed image or a score ring.
///   - title: The heading shown below `media`.
///   - description: Supporting copy shown below `title`.
///
/// Usage: `ImageHeader(media: .image(Icon.mainImage), title: "...", description: "...")`, or
/// `ImageHeader(media: .score(value: 78, maxScore: 100), title: "...", description: "...")`.
struct ImageHeader: View {
    let media: ImageHeaderMedia
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 0) {
            mediaView
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

    @ViewBuilder
    private var mediaView: some View {
        switch media {
        case .image(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
        case .score(let value, let maxScore):
            ScoreDisplay(score: value, maxScore: maxScore)
        }
    }
}

#Preview("Image") {
    ImageHeader(
        media: .image(Icon.mainImage),
        title: "How healthy are your finances?",
        description: "5 questions, 2 minutes."
    )
}

#Preview("Score") {
    ImageHeader(
        media: .score(value: 78, maxScore: 100),
        title: "Solid ground",
        description: "Good habits, small gains still available."
    )
}
