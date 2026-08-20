//
//  AppTextField.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI
import UIKit

/// The design system's single text field component (Figma): white, rounded, single-line
/// input with `Body/LG` typography — `Text.secondary` while showing the placeholder,
/// `Text.primary` once there's real input.
///
/// Every variant in Figma ("default", "with prefix", "with label", "error state") is this
/// same view, just configured differently, rather than a separate type per variant:
/// - **With prefix**: pass `prefix` (e.g. `"€"`) to show a symbol before the input.
/// - **With message**: pass `message` to show text below the field, leading-aligned to it.
/// - **Error state**: also pass `isError: true` to switch the border and `message` to
///   `Status.error` — `message` itself doesn't change, only its color and the border's.
///
/// The field expands to fill all available width (matching `AppButton`'s sizing), which is
/// what makes "leading-aligned to the field" a meaningful position for `message` rather than
/// depending on how wide the placeholder happens to be.
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
    /// Shown below the field, leading-aligned to it. `nil` omits it entirely. Same text
    /// whether it's a plain hint or an error — `isError` is what changes its color.
    var message: String?
    /// Whether `message` and the field's border render in `Status.error` instead of their
    /// default colors.
    var isError = false
    /// The keyboard shown while editing. `.default` unless the caller passes something more
    /// specific — e.g. `.decimalPad` for a numeric field.
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                .keyboardType(keyboardType)
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

            if let message {
                Text(message)
                    .typography(Typography.Body.SM.regular)
                    .foregroundStyle(isError ? DesignSystemColor.Status.error : DesignSystemColor.Text.secondary)
                    .padding(.top, AppTextFieldMetrics.labelGap)
            }
        }
    }
}

/// One `AppTextField` per Figma variant: default, with a currency prefix, with a message, and
/// in its error state.
private struct AppTextFieldPreviewContainer: View {
    @State private var defaultText = ""
    @State private var prefixText = ""
    @State private var messageText = ""
    @State private var errorText = "12345"

    var body: some View {
        VStack(spacing: Spacing.lg) {
            AppTextField(text: $defaultText, placeholder: "Placeholder")

            AppTextField(text: $prefixText, placeholder: "0.00", prefix: "€")

            AppTextField(text: $messageText, placeholder: "Placeholder", message: "Helper text")

            AppTextField(
                text: $errorText,
                placeholder: "Placeholder",
                message: "This field is required",
                isError: true
            )
        }
        .padding(.horizontal, Spacing.twoXl)
    }
}

#Preview {
    AppTextFieldPreviewContainer()
}
