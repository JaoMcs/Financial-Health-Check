//
//  HealthCheckSessionDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// Response shape shared by both session endpoints: start/resume and submit answer.
/// `sessionId` is the client-generated UUID used as the path parameter.
struct HealthCheckSessionDTO: DTO {
    /// The session identifier, echoed back by the server.
    var sessionId: String?
    /// `"in_progress"` while there are still questions left, `"completed"` once the session
    /// has a `result`.
    var status: String?
    /// The next question to answer. Present only while `status == "in_progress"`.
    var question: QuestionDTO?
    /// The final score and category. Present only while `status == "completed"`.
    var result: ResultDTO?
    /// How many questions have been answered out of the session's total.
    var progress: ProgressDTO?
}
