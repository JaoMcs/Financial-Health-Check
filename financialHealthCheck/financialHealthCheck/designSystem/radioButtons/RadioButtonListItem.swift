//
//  RadioButtonListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `RadioButtonListItem` state (Figma).
enum RadioButtonListItemConstants {
    /// Corner radius of the item's background/border.
    static let cornerRadius: CGFloat = 16
    /// The icon's top/leading/bottom padding, and the item's own trailing padding.
    static let edgePadding: CGFloat = Spacing.xl
    /// The icon's trailing padding — the gap between it and the label.
    static let iconLabelGap: CGFloat = Spacing.md
    /// Border width while unselected.
    static let borderWidth: CGFloat = 1
    /// Border width while selected.
    static let selectedBorderWidth: CGFloat = 2
}

/// The design system's single radio list item component (Figma): a rounded, tappable row
/// with a radio icon and a label. Background, border, and icon change with `isSelected`; the
/// label color doesn't.
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
                    .padding(.top, RadioButtonListItemConstants.edgePadding)
                    .padding(.leading, RadioButtonListItemConstants.edgePadding)
                    .padding(.bottom, RadioButtonListItemConstants.edgePadding)
                    .padding(.trailing, RadioButtonListItemConstants.iconLabelGap)

                Text(label)
                    .typography(Typography.Body.MD.medium)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.trailing, RadioButtonListItemConstants.edgePadding)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                    ? DesignSystemColor.Status.selectedSubtle
                    : DesignSystemColor.BackgroundAndSurface.surface
            )
            .overlay(
                RoundedRectangle(cornerRadius: RadioButtonListItemConstants.cornerRadius)
                    .strokeBorder(
                        isSelected ? DesignSystemColor.Status.selected : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isSelected
                            ? RadioButtonListItemConstants.selectedBorderWidth
                            : RadioButtonListItemConstants.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: RadioButtonListItemConstants.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

/// The design system's radio list (Figma): `RadioButtonListItem`s sharing a single selection.
/// Tapping an item selects it; there's no way to deselect back to `nil`.
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
