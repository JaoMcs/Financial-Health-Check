//
//  QuestionaryContent.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Foundation

/// Which selection component `QuestionaryView` renders below its header, mirroring
/// `QuestionType`.
enum QuestionaryContent {
    /// `.singleChoice` — a `RadioButtonList` over `options`.
    case singleChoice(options: [String])
    /// `.multipleChoice` — a `CheckboxList` over `options`.
    case multipleChoice(options: [String])
    /// `.number` — a single `AppTextField`.
    case number
}
