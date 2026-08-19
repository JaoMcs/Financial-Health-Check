//
//  Fixtures.swift
//  financialHealthCheckTests
//
//  Created by Joao on 19/08/26.
//

@testable import financialHealthCheck

/// Shared DTO builders for ViewModel tests — each test only passes the fields it actually
/// varies; everything else defaults to a plain placeholder value.
enum Fixtures {
    static func option(id: String, title: String) -> QuestionOptionDTO {
        QuestionOptionDTO(id: id, title: title)
    }

    static func singleChoiceQuestion(
        id: String = "question-1",
        title: String = "Title",
        description: String? = nil,
        options: [QuestionOptionDTO] = [option(id: "a", title: "A"), option(id: "b", title: "B")]
    ) -> QuestionDTO {
        QuestionDTO(id: id, title: title, description: description, type: .singleChoice, options: options)
    }

    static func multipleChoiceQuestion(
        id: String = "question-1",
        title: String = "Title",
        description: String? = nil,
        options: [QuestionOptionDTO] = [option(id: "a", title: "A"), option(id: "b", title: "B")],
        minSelections: Int? = nil,
        maxSelections: Int? = nil
    ) -> QuestionDTO {
        QuestionDTO(
            id: id,
            title: title,
            description: description,
            type: .multipleChoice,
            options: options,
            validation: QuestionValidationDTO(minSelections: minSelections, maxSelections: maxSelections)
        )
    }

    static func numberQuestion(
        id: String = "question-1",
        title: String = "Title",
        description: String? = nil,
        min: Int? = nil,
        max: Int? = nil
    ) -> QuestionDTO {
        QuestionDTO(
            id: id,
            title: title,
            description: description,
            type: .number,
            validation: QuestionValidationDTO(min: min, max: max)
        )
    }

    static func session(
        status: String = "in_progress",
        question: QuestionDTO? = nil,
        result: ResultDTO? = nil
    ) -> HealthCheckSessionDTO {
        HealthCheckSessionDTO(sessionId: "session-1", status: status, question: question, result: result)
    }
}
