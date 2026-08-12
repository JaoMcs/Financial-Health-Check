//
//  QuestionOptionDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// A selectable option for a `.singleChoice` or `.multipleChoice` question.
struct QuestionOptionDTO: DTO {
    /// The id to submit as the answer when this option is selected.
    var id: String?
    /// The label shown to the user.
    var title: String?
}
