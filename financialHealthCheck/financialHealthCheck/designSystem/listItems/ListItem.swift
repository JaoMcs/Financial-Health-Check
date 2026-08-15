//
//  ListItem.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// What `ListItem` shows on its trailing edge.
///
/// Usage: `.chevron` for a navigation row, `.money("120.00")` for a row that ends in a
/// currency value.
enum ListItemAccessory {
    /// A trailing chevron, for rows that navigate somewhere on tap.
    case chevron
    /// A trailing `"£<amount>"` label, built from `amount` — the currency symbol isn't a
    /// separate piece, it's baked into the one `Text` this renders.
    case money(String)
}

/// The design system's single, generic list item component (Figma): one row shape that
/// every kind of list row is, configured rather than subtyped. `leadingIcon`, `description`,
/// and `accessory` are independent of each other and can be combined freely — e.g. a row can
/// have both a leading icon and a description at once.
///
/// - **Default**: just `label`, `Text.primary` `Body/MD-Medium`, with a trailing `.chevron`.
/// - **With a description**: pass `description` to show a second line, `Text.secondary`
///   `Body/MD` (regular), directly under `label` with no gap between them.
/// - **With a leading icon**: pass `leadingIcon` to show it at 40x40 on the row's leading
///   edge; the label/description column no longer needs its own leading padding, since the
///   icon now supplies the row's left edge.
/// - **With a money accessory**: pass `accessory: .money(amount)` instead of the default
///   `.chevron` to end the row in a `Body/LG` `Text.secondary` currency value instead.
///
/// Unlike `RadioButtonListItem`/`CheckboxListItem`, this has no background, border, or
/// corner radius of its own — it's meant to sit inside whatever card or list container the
/// screen provides, not to look like one itself.
///
/// Usage: see the `#Preview` below.
struct ListItem: View {
    /// The row's main text.
    let label: String
    /// Second line shown under `label`, in `Text.secondary`. `nil` omits it entirely.
    var description: String? = nil
    /// Icon shown at 40x40 on the row's leading edge. `nil` omits it entirely.
    var leadingIcon: Image? = nil
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
                        .frame(width: ListItemMetrics.leadingIconSize, height: ListItemMetrics.leadingIconSize)
                        .padding(.leading, ListItemMetrics.leadingIconLeadingPadding)
                        .padding(.trailing, ListItemMetrics.leadingIconTrailingPadding)
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
                .padding(.leading, leadingIcon == nil ? ListItemMetrics.contentLeadingPadding : 0)
                .padding(.vertical, ListItemMetrics.contentVerticalPadding)
                .padding(.trailing, ListItemMetrics.contentAccessoryGap)

                Spacer(minLength: 0)

                switch accessory {
                case .chevron:
                        Icon.chevronRightSmall
                        .resizable()
                        .frame(width: ListItemMetrics.chevronSize, height: ListItemMetrics.chevronSize)
                        .foregroundStyle(DesignSystemColor.BorderAndIcon.iconSecondary)

                case .money(let amount):
                    Text("£\(amount)")
                        .typography(Typography.Body.LG.regular)
                        .foregroundStyle(DesignSystemColor.Text.secondary)
                }
            }
            .padding(.trailing, ListItemMetrics.rowTrailingPadding)
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
