//
//  QuestionType.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// The kind of answer a `QuestionDTO` expects.
///
/// Usage: `switch question.type { case .singleChoice: ... }` to decide how to render
/// `QuestionDTO.options`/`validation` and how to shape the submitted `AnswerValue`.
enum QuestionType: String, Codable {
    /// A single option, submitted as that option's id (`String`).
    case singleChoice = "single_choice"
    /// One or more options, submitted as an array of option ids (`[String]`).
    case multipleChoice = "multiple_choice"
    /// A numeric answer, submitted as a `Double`.
    case number = "number"
}
