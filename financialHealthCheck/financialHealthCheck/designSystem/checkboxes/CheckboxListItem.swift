//
//  CheckboxListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// The design system's single checkbox list item component (Figma): a rounded, tappable row
/// with a 24x24 checkbox icon and a label. Similar to `RadioButtonListItem`, but for
/// multiple selections instead of one — see `CheckboxList`.
///
/// - **Checked**: `Status.selectedSubtle` background, `Status.selected` border at 2pt,
///   `Icon.checkboxSelected`.
/// - **Unchecked**: `Surface` (white) background, light `Border` at 1pt,
///   `Icon.checkboxNotSelected`.
///
/// The label's color doesn't change between states — only the background, border, and icon
/// do. The icon carries its own padding rather than sharing the row's: 20pt on its leading
/// edge, 24pt on its top and bottom, and 12pt on its trailing edge (the gap to the label) —
/// the row then adds its own 20pt trailing padding to match the icon's leading inset.
///
/// Usage: see the `#Preview` below.
struct CheckboxListItem: View {
    /// The text shown next to the checkbox icon.
    let label: String
    /// Whether this item is currently checked.
    let isChecked: Bool
    /// Called when the item is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                (isChecked ? Icon.checkboxSelected : Icon.checkboxNotSelected)
                    .resizable()
                    .frame(width: CheckboxListItemMetrics.iconSize, height: CheckboxListItemMetrics.iconSize)
                    .padding(.leading, CheckboxListItemMetrics.iconLeadingPadding)
                    .padding(.top, CheckboxListItemMetrics.iconVerticalPadding)
                    .padding(.bottom, CheckboxListItemMetrics.iconVerticalPadding)
                    .padding(.trailing, CheckboxListItemMetrics.iconLabelGap)

                Text(label)
                    .typography(Typography.Body.MD.medium)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.trailing, CheckboxListItemMetrics.iconLeadingPadding)
            .frame(maxWidth: .infinity)
            .background(
                isChecked
                    ? DesignSystemColor.Status.selectedSubtle
                    : DesignSystemColor.BackgroundAndSurface.surface
            )
            .overlay(
                RoundedRectangle(cornerRadius: CheckboxListItemMetrics.cornerRadius)
                    .strokeBorder(
                        isChecked ? DesignSystemColor.Status.selected : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isChecked
                            ? CheckboxListItemMetrics.checkedBorderWidth
                            : CheckboxListItemMetrics.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: CheckboxListItemMetrics.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

/// The design system's checkbox list (Figma): `N` `CheckboxListItem`s sharing one set of
/// checked options, `Spacing.sm` apart. Tapping an item toggles it in `selections`,
/// independent of every other item.
///
/// Usage: see the `#Preview` below.
struct CheckboxList: View {
    /// The currently checked options.
    @Binding var selections: Set<String>
    /// The options shown, in order.
    let options: [String]

    var body: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(options, id: \.self) { option in
                CheckboxListItem(label: option, isChecked: selections.contains(option)) {
                    if selections.contains(option) {
                        selections.remove(option)
                    } else {
                        selections.insert(option)
                    }
                }
            }
        }
    }
}

/// A `CheckboxList` with the first two options pre-checked.
private struct CheckboxListPreviewContainer: View {
    @State private var selections: Set<String> = ["Option 1", "Option 2"]

    var body: some View {
        CheckboxList(selections: $selections, options: ["Option 1", "Option 2", "Option 3"])
            .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    CheckboxListPreviewContainer()
}
