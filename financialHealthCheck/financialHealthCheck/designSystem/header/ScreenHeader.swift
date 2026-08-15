//
//  ScreenHeader.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// The design system's screen header (Figma): a caption, a title, and a description, stacked
/// vertically, all left-aligned and stretching to the same trailing edge.
///
/// - **Caption**: `Body/SM-Medium`, `Text.secondary`.
/// - **Title**: `Heading/SM`, `Text.primary`.
/// - **Description**: `Body/MD`, `Text.secondary`.
///
/// Usage: see the `#Preview` below.
struct ScreenHeader: View {
    /// Small label shown above `title`.
    let caption: String
    /// The header's main heading.
    let title: String
    /// Supporting copy shown below `title`.
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(caption)
                .typography(Typography.Body.SM.medium)
                .foregroundStyle(DesignSystemColor.Text.secondary)

            Text(title)
                .typography(Typography.Heading.sm)
                .foregroundStyle(DesignSystemColor.Text.primary)

            Text(description)
                .typography(Typography.Body.MD.regular)
                .foregroundStyle(DesignSystemColor.Text.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
    }
}

#Preview {
    ScreenHeader(
        caption: "Step 2 of 5",
        title: "About your income",
        description: "This helps us understand your financial situation and give you more accurate results."
    )
}
