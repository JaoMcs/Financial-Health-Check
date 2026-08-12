//
//  QuestionValidationDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// Constraints an answer must satisfy before it can be submitted for a given question.
struct QuestionValidationDTO: DTO {
    /// Whether an answer must be provided at all.
    var required: Bool?
    /// Minimum allowed value. Applies to `.number` questions.
    var min: Int?
    /// Maximum allowed value. Applies to `.number` questions.
    var max: Int?
    /// Minimum number of options that must be selected. Applies to `.multipleChoice` questions.
    var minSelections: Int?
    /// Maximum number of options that may be selected. Applies to `.multipleChoice` questions.
    var maxSelections: Int?
}
