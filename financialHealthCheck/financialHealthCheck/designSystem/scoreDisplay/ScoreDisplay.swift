//
//  ScoreDisplay.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// Layout values for `ScoreDisplay` (Figma).
enum ScoreDisplayConstants {
    /// Width and height of the ring.
    static let size: CGFloat = 240
    /// Thickness of the ring's stroke.
    static let lineWidth: CGFloat = 24
}

/// The design system's circular score ring (Figma): a ring filled clockwise to reflect `score`
/// out of `maxScore`, with both values centered inside.
///
/// - Parameters:
///   - score: The value to fill the ring to, and show in its center.
///   - maxScore: The value `score` is out of.
struct ScoreDisplay: View {
    let score: Int
    let maxScore: Int

    private var progress: CGFloat {
        CGFloat(score) / CGFloat(maxScore)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(DesignSystemColor.Status.selectedSubtle, style: strokeStyle)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(DesignSystemColor.Primary.primary, style: strokeStyle)
                .rotationEffect(.degrees(-90))

            VStack(spacing: Spacing.xs) {
                Text("\(score)")
                    .typography(Typography.Heading.xl)
                    .foregroundStyle(DesignSystemColor.Text.primary)

                Text("/\(maxScore)")
                    .typography(Typography.Body.LG.medium)
                    .foregroundStyle(DesignSystemColor.Text.secondary)
            }
        }
        .frame(width: ScoreDisplayConstants.size, height: ScoreDisplayConstants.size)
    }

    private var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: ScoreDisplayConstants.lineWidth, lineCap: .square)
    }
}

#Preview {
    ScoreDisplay(score: 78, maxScore: 100)
}
