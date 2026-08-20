//
//  ResultDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// The outcome of a completed health-check session, returned in
/// `HealthCheckSessionDTO.result` once `status == "completed"`.
struct ResultDTO: DTO {
    /// The overall score, from 0 to 100.
    var score: Int?
    /// The band `score` falls into.
    var category: ResultCategory?
}
