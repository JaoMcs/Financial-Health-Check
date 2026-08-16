//
//  ScoreDisplay.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import SwiftUI

/// The design system's circular score ring (Figma): a 240x240 ring, filled clockwise from the
/// top to reflect `score` out of `maxScore`, with the score and "/`maxScore`" centered inside.
/// Same `Circle().trim(from:to:).rotationEffect(-90°)` technique as the article cited in the
/// README credits, adapted to a score out of `maxScore` instead of a countdown.
///
/// - Parameters:
///   - score: The value to fill the ring to, and show in its center.
///   - maxScore: The value `score` is out of — shown as "/`maxScore`", and what `score` is
///     divided by to compute the fill.
///
/// Usage: `ScoreDisplay(score: 78, maxScore: 100)`.
struct ScoreDisplay: View {
    private static let size: CGFloat = 240
    private static let lineWidth: CGFloat = 24

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
        .frame(width: Self.size, height: Self.size)
    }

    private var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: Self.lineWidth, lineCap: .square)
    }
}

#Preview {
    ScoreDisplay(score: 78, maxScore: 100)
}
