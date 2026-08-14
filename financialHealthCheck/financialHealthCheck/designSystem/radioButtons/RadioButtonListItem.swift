//
//  RadioButtonListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// The design system's single radio list item component (Figma): a rounded, tappable row
/// with a radio icon and a label.
///
/// - **Selected**: `Status.selectedSubtle` background, `Status.selected` border at 2pt,
///   `Icon.radioSelected`.
/// - **Unselected**: `Surface` (white) background, light `Border` at 1pt,
///   `Icon.radioNotSelected`.
///
/// The label's color doesn't change between states — only the background, border, and icon
/// do. The icon carries its own padding rather than sharing the row's: 20pt on its top,
/// leading, and bottom, and 12pt on its trailing edge (the gap to the label) — the row then
/// adds its own 20pt trailing padding to match the icon's leading inset.
///
/// Usage: see the `#Preview` below.
struct RadioButtonListItem: View {
    /// The text shown next to the radio icon.
    let label: String
    /// Whether this item is the one currently selected.
    let isSelected: Bool
    /// Called when the item is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                (isSelected ? Icon.radioSelected : Icon.radioNotSelected)
                    .padding(.top, RadioButtonListItemMetrics.edgePadding)
                    .padding(.leading, RadioButtonListItemMetrics.edgePadding)
                    .padding(.bottom, RadioButtonListItemMetrics.edgePadding)
                    .padding(.trailing, RadioButtonListItemMetrics.iconLabelGap)

                Text(label)
                    .typography(Typography.Body.MD.medium)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.trailing, RadioButtonListItemMetrics.edgePadding)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                    ? DesignSystemColor.Status.selectedSubtle
                    : DesignSystemColor.BackgroundAndSurface.surface
            )
            .overlay(
                RoundedRectangle(cornerRadius: RadioButtonListItemMetrics.cornerRadius)
                    .strokeBorder(
                        isSelected ? DesignSystemColor.Status.selected : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isSelected
                            ? RadioButtonListItemMetrics.selectedBorderWidth
                            : RadioButtonListItemMetrics.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: RadioButtonListItemMetrics.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

/// The design system's radio list (Figma): `N` `RadioButtonListItem`s sharing a single
/// selection, `Spacing.sm` apart. Tapping an item selects it; radio semantics mean there's no
/// way to deselect back to `nil` once one option is chosen.
///
/// Usage: see the `#Preview` below.
struct RadioButtonList: View {
    /// The currently chosen option.
    @Binding var selection: String?
    /// The options shown, in order.
    let options: [String]

    var body: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(options, id: \.self) { option in
                RadioButtonListItem(label: option, isSelected: option == selection) {
                    selection = option
                }
            }
        }
    }
}

/// A `RadioButtonList` with the second option pre-selected.
private struct RadioButtonListPreviewContainer: View {
    @State private var selection: String? = "Option 2"

    var body: some View {
        RadioButtonList(selection: $selection, options: ["Option 1", "Option 2", "Option 3"])
            .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    RadioButtonListPreviewContainer()
}
