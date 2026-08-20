//
//  AppTextField.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import SwiftUI
import UIKit

/// Layout values shared by every `AppTextField` configuration (Figma).
enum AppTextFieldConstants {
    /// Corner radius of the field's background/border.
    static let cornerRadius: CGFloat = 16
    /// Leading/trailing padding between the field's content and its edge.
    static let horizontalPadding: CGFloat = Spacing.lg
    /// Top/bottom padding between the field's content and its edge. Not specified in Figma —
    /// chosen to keep the field comfortably tall next to `horizontalPadding`.
    static let verticalPadding: CGFloat = Spacing.md
    /// Border width for the default state.
    static let borderWidth: CGFloat = 1
    /// Border width once the field has an `errorMessage`.
    static let errorBorderWidth: CGFloat = 2
    /// Gap between the field and its `label` (above) or `errorMessage` (below).
    static let labelGap: CGFloat = Spacing.xs
    /// Gap between an optional `prefix` and the input text. Not specified in Figma — reuses
    /// the same gap `AppButton` uses between an icon and its label.
    static let prefixGap: CGFloat = Spacing.sm
}

/// The design system's single text field component (Figma): white, rounded, single-line
/// input with `Body/LG` typography, an optional prefix, and an optional error state.
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
            HStack(spacing: AppTextFieldConstants.prefixGap) {
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
            .padding(.horizontal, AppTextFieldConstants.horizontalPadding)
            .padding(.vertical, AppTextFieldConstants.verticalPadding)
            .frame(maxWidth: .infinity)
            .background(DesignSystemColor.BackgroundAndSurface.surface)
            .overlay(
                RoundedRectangle(cornerRadius: AppTextFieldConstants.cornerRadius)
                    .strokeBorder(
                        isError ? DesignSystemColor.Status.error : DesignSystemColor.BorderAndIcon.border,
                        lineWidth: isError ? AppTextFieldConstants.errorBorderWidth : AppTextFieldConstants.borderWidth
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTextFieldConstants.cornerRadius))

            if let message {
                Text(message)
                    .typography(Typography.Body.SM.regular)
                    .foregroundStyle(isError ? DesignSystemColor.Status.error : DesignSystemColor.Text.secondary)
                    .padding(.top, AppTextFieldConstants.labelGap)
            }
        }
    }
}

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
