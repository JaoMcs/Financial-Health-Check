//
//  AppSelectControl.swift
//  financialHealthCheck
//
//  Created by Joao on 14/08/26.
//

import SwiftUI

/// Reports the trigger's rendered height up to `AppSelectControl`, so it can offset the
/// options overlay to sit exactly below it without reserving that space in the layout.
private struct TriggerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    /// Keeps the most recent height reported, as required by `PreferenceKey`.
    ///
    /// - Parameters:
    ///   - value: The height accumulated so far.
    ///   - nextValue: Closure returning the next candidate height.
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// The design system's single select/dropdown component (Figma): a rounded trigger showing
/// the current selection (or a placeholder) that expands into a list of `options` below it.
///
/// - **Empty**: light `Border`, `Text.secondary` placeholder.
/// - **Filled**: dark `Status.selected` border, `Text.primary` value.
/// - **Open**: reveals `options` below the trigger, same dark border, chevron flips up. Rows
///   share one rounded group with no divider; the selected row gets `Status.selectedSubtle`.
///   Tapping the selected row again clears `selection`.
/// - **Error**: `isError` switches the border to `Status.error`, overriding filled/open looks.
///   It's a `@Binding` so picking a real option clears it automatically; clearing back to
///   `nil` does not.
///
/// The options list overlays below the trigger instead of pushing sibling views down.
///
/// Usage: see the `#Preview` below.
struct AppSelectControl: View {
    /// The currently chosen option. `nil` shows `placeholder` instead.
    @Binding var selection: String?
    /// The options shown, in order, once the control is open.
    let options: [String]
    /// Shown, in `Text.secondary`, whenever `selection` is `nil`.
    let placeholder: String
    /// Whether the trigger shows its error border. Cleared to `false` by the control itself
    /// once `selection` is set to a real option.
    @Binding var isError: Bool

    @State private var isOpen = false
    @State private var triggerHeight: CGFloat = 0

    /// The trigger's border color: error red wins over the open/filled dark tone, which in
    /// turn wins over the default light tone.
    private var borderColor: Color {
        if isError { DesignSystemColor.Status.error }
        else if isOpen { DesignSystemColor.Status.selected }
        else if selection != nil { DesignSystemColor.Status.selected }
        else { DesignSystemColor.BorderAndIcon.border }
    }

    /// The trigger's border width: thicker while open or in error, otherwise the default.
    private var borderWidth: CGFloat {
        isOpen || isError
            ? AppSelectControlMetrics.openOrErrorBorderWidth
            : AppSelectControlMetrics.borderWidth
    }

    var body: some View {
        trigger
            .overlay(alignment: .top) {
                if isOpen {
                    optionsList
                        .offset(y: triggerHeight + AppSelectControlMetrics.optionsGap)
                }
            }
            .zIndex(isOpen ? 1 : 0)
    }

    private var trigger: some View {
        Button {
            isOpen.toggle()
        } label: {
            HStack(spacing: AppSelectControlMetrics.horizontalPadding) {
                Text(selection ?? placeholder)
                    .typography(Typography.Body.LG.regular)
                    .foregroundStyle(
                        selection == nil
                            ? DesignSystemColor.Text.secondary
                            : DesignSystemColor.Text.primary
                    )
                    .lineLimit(1)

                Spacer(minLength: 0)

                (isOpen ? Icon.chevronTopSmall : Icon.chevronDownSmall)
                    .foregroundStyle(DesignSystemColor.BorderAndIcon.iconSecondary)
            }
            .padding(.horizontal, AppSelectControlMetrics.horizontalPadding)
            .padding(.vertical, AppSelectControlMetrics.verticalPadding)
            .frame(maxWidth: .infinity)
            .background(DesignSystemColor.BackgroundAndSurface.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppSelectControlMetrics.cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppSelectControlMetrics.cornerRadius))
        }
        .buttonStyle(.plain)
        .background(
            GeometryReader { proxy in
                Color.clear.preference(key: TriggerHeightPreferenceKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(TriggerHeightPreferenceKey.self) { triggerHeight = $0 }
    }

    private var optionsList: some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                optionRow(option)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: AppSelectControlMetrics.cornerRadius)
                .strokeBorder(DesignSystemColor.BorderAndIcon.border, lineWidth: AppSelectControlMetrics.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppSelectControlMetrics.cornerRadius))
    }

    /// One row of `optionsList`: tapping it selects `option`, or clears `selection` if
    /// `option` was already the current selection.
    ///
    /// - Parameter option: The `String` option this row represents.
    private func optionRow(_ option: String) -> some View {
        Button {
            if option == selection {
                selection = nil
            } else {
                selection = option
                isError = false
            }
            isOpen = false
        } label: {
            HStack(spacing: 0) {
                Text(option)
                    .typography(Typography.Body.LG.regular)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, AppSelectControlMetrics.horizontalPadding)
            .padding(.vertical, AppSelectControlMetrics.verticalPadding)
            .frame(maxWidth: .infinity)
            .background(
                option == selection
                    ? DesignSystemColor.Status.selectedSubtle
                    : DesignSystemColor.BackgroundAndSurface.surface
            )
        }
        .buttonStyle(.plain)
    }
}

/// One `AppSelectControl` per Figma variant: empty, filled, and error. The open look is only
/// reachable by tapping a control in the live canvas, since `isOpen` is private.
private struct AppSelectControlPreviewContainer: View {
    @State private var defaultSelection: String? = nil
    @State private var chosenSelection: String? = "Option 2"
    @State private var errorSelection: String? = nil
    @State private var isError = true

    private let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack(spacing: Spacing.lg) {
            AppSelectControl(
                selection: $defaultSelection,
                options: options,
                placeholder: "Placeholder",
                isError: .constant(false)
            )

            AppSelectControl(
                selection: $chosenSelection,
                options: options,
                placeholder: "Placeholder",
                isError: .constant(false)
            )

            AppSelectControl(
                selection: $errorSelection,
                options: options,
                placeholder: "Placeholder",
                isError: $isError
            )
        }
        .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    AppSelectControlPreviewContainer()
}
