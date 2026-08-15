//
//  AppTextField.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI

/// The design system's single text field component (Figma): white, rounded, single-line
/// input with `Body/LG` typography — `Text.secondary` while showing the placeholder,
/// `Text.primary` once there's real input.
///
/// Every variant in Figma ("default", "with prefix", "with label", "error state") is this
/// same view, just configured differently, rather than a separate type per variant:
/// - **With prefix**: pass `prefix` (e.g. `"£"`) to show a symbol before the input.
/// - **With label**: pass `label` to show text above the field, leading-aligned to it.
/// - **Error state**: pass `errorMessage` to switch the border to `Status.error` at 2pt and
///   show that message below the field, also leading-aligned.
///
/// The field expands to fill all available width (matching `AppButton`'s sizing), which is
/// what makes "leading-aligned to the field" a meaningful position for `label` and
/// `errorMessage` rather than depending on how wide the placeholder happens to be.
///
/// `TextField`'s `prompt` parameter must stay a `Text`, so the placeholder is styled through
/// `Text`'s own `font`/`tracking`/`foregroundColor` overloads (which return `Text`) instead of
/// this file's usual `.typography`/`.foregroundStyle` view modifiers (which return `some
/// View` and don't type-check there).
///
/// Usage: see the `#Preview` below.
struct AppTextField: View {
    /// The field's current input.
    @Binding var text: String
    /// Shown, in `Text.secondary`, whenever `text` is empty.
    let placeholder: String
    /// Symbol shown before the input (e.g. a currency sign). `nil` omits it entirely.
    var prefix: String?
    /// Text shown above the field, leading-aligned to it. `nil` omits it entirely.
    var label: String?
    /// Message shown below the field, leading-aligned to it, and what switches the field
    /// into its error border. `nil` omits it entirely and keeps the default border.
    var errorMessage: String?

    private var isError: Bool { errorMessage != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let label {
                Text(label)
                    .typography(Typography.Body.SM.medium)
                    .foregroundStyle(DesignSystemColor.Text.primary)
                    .padding(.bottom, AppTextFieldMetrics.labelGap)
            }

            HStack(spacing: AppTextFieldMetrics.prefixGap) {
                if let prefix {
                    Text(prefix)
                        .typography(Typography.Body.LG.regular)
                        .foregroundStyle(DesignSystemColor.Text.primary)
                }

                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .font(Typography.Body.LG.regular.font)
                        .tracking(Typography.Body.LG.regular.tracking)
                        .foregroundColor(DesignSystemColor.Text.secondary)
                )
                .typography(Typography.Body.LG.regular)
                .foregroundStyle(DesignSystemColor.Text.primary)
                .textFieldStyle(.plain)
            }
            .padding(.horizontal, AppTextFieldMetrics.horizontalPadding)
            .padding(.vertical, AppTextFieldMetrics.verticalPadding)
            .frame(maxWidth: .infinity)
            .background(DesignSystemColor.BackgroundAndSurface.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppTextFieldMetrics.cornerRadius)
                    .strokeBorder(
                        isError ? DesignSystemColor.Status.error : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isError ? AppTextFieldMetrics.errorBorderWidth : AppTextFieldMetrics.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTextFieldMetrics.cornerRadius))

            if let errorMessage {
                Text(errorMessage)
                    .typography(Typography.Body.SM.regular)
                    .foregroundStyle(DesignSystemColor.Status.error)
                    .padding(.top, AppTextFieldMetrics.labelGap)
            }
        }
    }
}

/// One `AppTextField` per Figma variant: default, with a currency prefix, with a label, and
/// in its error state.
private struct AppTextFieldPreviewContainer: View {
    @State private var defaultText = ""
    @State private var prefixText = ""
    @State private var labelText = ""
    @State private var errorText = "12345"

    var body: some View {
        VStack(spacing: Spacing.lg) {
            AppTextField(text: $defaultText, placeholder: "Placeholder")

            AppTextField(text: $prefixText, placeholder: "0.00", prefix: "£")

            AppTextField(text: $labelText, placeholder: "Placeholder", label: "Label")

            AppTextField(
                text: $errorText,
                placeholder: "Placeholder",
                errorMessage: "This field is required"
            )
        }
        .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    AppTextFieldPreviewContainer()
}
