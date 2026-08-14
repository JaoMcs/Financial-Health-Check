//
//  ResultDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// The outcome of a completed health-check session, returned in
/// `HealthCheckSessionDTO.result` once `status == "completed"`.
///
/// Usage: read `HealthCheckSessionDTO.result` once `status == "completed"` to show
/// `score`/`category` on the results screen.
struct ResultDTO: DTO {
    /// The overall score, from 0 to 100.
    var score: Int?
    /// The band `score` falls into: `"poor"`, `"fair"`, `"good"`, or `"excellent"`.
    var category: String?
}
