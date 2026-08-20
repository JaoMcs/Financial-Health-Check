//
//  ImageHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// Layout values for `ImageHeader` (Figma).
enum ImageHeaderConstants {
    /// Width and height of `.image` media. `.score` media sizes itself, via
    /// `ScoreDisplayConstants.size`.
    static let imageSize: CGFloat = 200
}

/// What `ImageHeader` shows above its title/description.
enum ImageHeaderMedia {
    /// A fixed image.
    case image(Image)
    /// A `ScoreDisplay` showing `value` out of `maxScore`.
    case score(value: Int, maxScore: Int)
}

/// The design system's centered image header (Figma): `media`, a title, and a description,
/// stacked vertically and center-aligned.
///
/// - Parameters:
///   - media: Shown at the top — either a fixed image or a score ring.
///   - title: The heading shown below `media`.
///   - description: Supporting copy shown below `title`.
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
                .frame(width: ImageHeaderConstants.imageSize, height: ImageHeaderConstants.imageSize)
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
