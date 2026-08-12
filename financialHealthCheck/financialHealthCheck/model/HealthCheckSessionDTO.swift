//
//  HealthCheckSessionDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// Response shape shared by both session endpoints:
/// `POST /health-check/v1/sessions/{sessionId}` (start/resume) and
/// `POST /health-check/v1/sessions/{sessionId}/submission` (submit answer).
///
/// `sessionId` is the client-generated UUID used as the path parameter — sending the same
/// id again resumes that session instead of starting a new one.
struct HealthCheckSessionDTO: DTO {
    /// The session identifier, echoed back by the server.
    var sessionId: String?
    /// `"in_progress"` while there are still questions left, `"completed"` once the
    /// session has a `result`.
    var status: String?
    /// The next question to answer. Present only while `status == "in_progress"`.
    var question: QuestionDTO?
    /// The final score and category. Present only while `status == "completed"`.
    var result: ResultDTO?
    /// How many questions have been answered out of the session's total.
    var progress: ProgressDTO?
}
