//
//  ListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Layout values shared by every `ListItem` configuration (Figma).
enum ListItemConstants {
    /// The label/description column's leading padding, used only when there's no
    /// `leadingIcon` (the icon supplies the row's leading edge itself otherwise).
    static let contentLeadingPadding: CGFloat = Spacing.lg
    /// The label/description column's top/bottom padding. Not part of the spacing scale —
    /// Figma specifies 17pt exactly.
    static let contentVerticalPadding: CGFloat = 17
    /// The label/description column's trailing padding — the minimum gap to `accessory`.
    static let contentAccessoryGap: CGFloat = Spacing.md
    /// The row's own trailing padding, from `accessory` to the row's edge.
    static let rowTrailingPadding: CGFloat = Spacing.lg
    /// Width and height the trailing chevron is resized to.
    static let chevronSize: CGFloat = 24
    /// Width and height `leadingIcon` is resized to.
    static let leadingIconSize: CGFloat = 40
    /// `leadingIcon`'s own leading padding.
    static let leadingIconLeadingPadding: CGFloat = Spacing.lg
    /// `leadingIcon`'s own trailing padding — the gap to the label/description column.
    static let leadingIconTrailingPadding: CGFloat = Spacing.md
}

/// What `ListItem` shows on its trailing edge.
enum ListItemAccessory {
    /// A trailing chevron, for rows that navigate somewhere on tap.
    case chevron
    /// A trailing `"£<amount>"` label built from `amount`.
    case money(String)
}

/// The design system's single, generic list item component (Figma): one row shape, configured
/// rather than subtyped. `leadingIcon`, `description`, and `accessory` are independent and can
/// be combined freely. Unlike `RadioButtonListItem`/`CheckboxListItem`, it has no background,
/// border, or corner radius of its own.
struct ListItem: View {
    /// The row's main text.
    let label: String
    /// Second line shown under `label`, in `Text.secondary`. `nil` omits it entirely.
    var description: String?
    /// Icon shown at 40x40 on the row's leading edge. `nil` omits it entirely.
    var leadingIcon: Image?
    /// What the row shows on its trailing edge.
    var accessory: ListItemAccessory = .chevron
    /// Called when the row is tapped.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                if let leadingIcon {
                    leadingIcon
                        .resizable()
                        .frame(width: ListItemConstants.leadingIconSize, height: ListItemConstants.leadingIconSize)
                        .padding(.leading, ListItemConstants.leadingIconLeadingPadding)
                        .padding(.trailing, ListItemConstants.leadingIconTrailingPadding)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(label)
                        .typography(Typography.Body.MD.medium)
                        .foregroundStyle(DesignSystemColor.Text.primary)
                        .lineLimit(1)

                    if let description {
                        Text(description)
                            .typography(Typography.Body.MD.regular)
                            .foregroundStyle(DesignSystemColor.Text.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(.leading, leadingIcon == nil ? ListItemConstants.contentLeadingPadding : 0)
                .padding(.vertical, ListItemConstants.contentVerticalPadding)
                .padding(.trailing, ListItemConstants.contentAccessoryGap)

                Spacer(minLength: 0)

                switch accessory {
                case .chevron:
                        Icon.chevronRightSmall
                        .resizable()
                        .frame(width: ListItemConstants.chevronSize, height: ListItemConstants.chevronSize)
                        .foregroundStyle(DesignSystemColor.BorderAndIcon.iconSecondary)

                case .money(let amount):
                    Text("£\(amount)")
                        .typography(Typography.Body.LG.regular)
                        .foregroundStyle(DesignSystemColor.Text.secondary)
                }
            }
            .padding(.trailing, ListItemConstants.rowTrailingPadding)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

/// One `ListItem` per named Figma variant: `defaultItem`, with a description, with a leading
/// icon, and with a money accessory.
#Preview {
    VStack(spacing: 0) {
        ListItem(label: "Notifications") {}

        ListItem(label: "Payment plan", description: "Monthly, due on the 1st") {}

        ListItem(label: "Savings account", leadingIcon: Icon.chevronDownSmall) {}

        ListItem(label: "Current balance", accessory: .money("1,204.50")) {}
    }
}
