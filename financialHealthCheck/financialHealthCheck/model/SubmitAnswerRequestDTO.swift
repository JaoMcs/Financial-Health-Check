//
//  SubmitAnswerRequestDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// Request body for `POST /health-check/v1/sessions/{sessionId}/submission`.
///
/// The response to this request is a `HealthCheckSessionDTO` — either the next question, or
/// the final result if this was the last one.
///
/// Usage: `SubmitAnswerRequestDTO(questionId: question.id, answer: .text(selectedOptionId))`.
struct SubmitAnswerRequestDTO: DTO {
    /// The id of the question being answered — must match the current question's `id`.
    var questionId: String?
    /// The answer value. Its underlying JSON type depends on the question's `type`: a string
    /// for `single_choice`, an array of strings for `multiple_choice`, or a number for
    /// `number`.
    var answer: AnswerValue?
}
