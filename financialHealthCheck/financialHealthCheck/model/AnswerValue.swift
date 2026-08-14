//
//  AnswerValue.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// The value submitted as a question's answer.
///
/// The API expects a different JSON type depending on the question type, so this encodes and
/// decodes as a single raw value instead of a keyed object: a string for `single_choice`, an
/// array of strings for `multiple_choice`, or a number for `number`.
///
/// Usage: `SubmitAnswerRequestDTO(questionId: id, answer: .text("opt_1"))`.
enum AnswerValue {
    /// `single_choice` — the selected option's id.
    case text(String)
    /// `multiple_choice` — the selected options' ids.
    case choices([String])
    /// `number` — the numeric answer.
    case number(Double)
}

extension AnswerValue: Codable {
    /// Decodes whichever of `String`, `[String]`, or `Double` the JSON value actually is.
    ///
    /// - Parameter decoder: The `Decoder` supplying a single, un-keyed JSON value.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .text(value)
        } else if let value = try? container.decode([String].self) {
            self = .choices(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else {
            throw DecodingError.typeMismatch(
                AnswerValue.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "AnswerValue did not match String, [String], or Double"
                )
            )
        }
    }

    /// Encodes the wrapped value alone — a `String`, `[String]`, or `Double` — with no
    /// wrapping key.
    ///
    /// - Parameter encoder: The `Encoder` to write the single raw value to.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let value):
            try container.encode(value)
        case .choices(let values):
            try container.encode(values)
        case .number(let value):
            try container.encode(value)
        }
    }
}
