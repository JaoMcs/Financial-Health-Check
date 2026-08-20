//
//  CheckboxListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `CheckboxListItem` state (Figma).
enum CheckboxListItemConstants {
    /// Corner radius of the item's background/border.
    static let cornerRadius: CGFloat = 16
    /// Width and height the checkbox icon is resized to.
    static let iconSize: CGFloat = 24
    /// The icon's leading padding, and the item's own trailing padding.
    static let iconLeadingPadding: CGFloat = Spacing.xl
    /// The icon's top/bottom padding.
    static let iconVerticalPadding: CGFloat = Spacing.twoXl
    /// The icon's trailing padding — the gap between it and the label. Not specified in
    /// Figma — reuses `RadioButtonListItem`'s icon/label gap.
    static let iconLabelGap: CGFloat = Spacing.md
    /// Border width while unchecked.
    static let borderWidth: CGFloat = 1
    /// Border width while checked.
    static let checkedBorderWidth: CGFloat = 2
}

/// The design system's single checkbox list item component (Figma): a rounded, tappable row
/// with a checkbox icon and a label, for multiple selections — see `CheckboxList`. Background,
/// border, and icon change with `isChecked`; the label color doesn't.
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
                    .frame(width: CheckboxListItemConstants.iconSize, height: CheckboxListItemConstants.iconSize)
                    .padding(.leading, CheckboxListItemConstants.iconLeadingPadding)
                    .padding(.top, CheckboxListItemConstants.iconVerticalPadding)
                    .padding(.bottom, CheckboxListItemConstants.iconVerticalPadding)
                    .padding(.trailing, CheckboxListItemConstants.iconLabelGap)

                Text(label)
                    .typography(Typography.Body.MD.medium)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.trailing, CheckboxListItemConstants.iconLeadingPadding)
            .frame(maxWidth: .infinity)
            .background(
                isChecked
                    ? DesignSystemColor.Status.selectedSubtle
                    : DesignSystemColor.BackgroundAndSurface.surface
            )
            .overlay(
                RoundedRectangle(cornerRadius: CheckboxListItemConstants.cornerRadius)
                    .strokeBorder(
                        isChecked ? DesignSystemColor.Status.selected : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isChecked
                            ? CheckboxListItemConstants.checkedBorderWidth
                            : CheckboxListItemConstants.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: CheckboxListItemConstants.cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

/// The design system's checkbox list (Figma): `CheckboxListItem`s sharing one set of checked
/// options. Tapping an item toggles it in `selections`, independent of every other item.
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
