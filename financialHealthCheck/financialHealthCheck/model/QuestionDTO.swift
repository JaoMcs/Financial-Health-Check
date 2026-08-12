//
//  QuestionDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// A single question served by the health-check session, returned in
/// `HealthCheckSessionDTO.question`.
struct QuestionDTO: DTO {
    /// Unique identifier for this question, sent back in `SubmitAnswerRequestDTO.questionId`.
    var id: String?
    /// The question's headline, shown to the user.
    var title: String?
    /// Optional supporting copy shown below the title.
    var description: String?
    /// Which kind of answer this question expects, and therefore how `options` and
    /// `validation` should be interpreted.
    var type: QuestionType?
    /// The selectable options. Present for `.singleChoice` and `.multipleChoice`.
    var options: [QuestionOptionDTO]?
    /// The constraints the answer must satisfy before it can be submitted.
    var validation: QuestionValidationDTO?
}
