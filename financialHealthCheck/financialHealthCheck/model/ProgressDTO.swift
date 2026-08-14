//
//  ProgressDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// How far along the session is, returned alongside every question or result.
///
/// Usage: read as `HealthCheckSessionDTO.progress`, e.g. to render "Question `current` of
/// `total`".
struct ProgressDTO: DTO {
    /// The number of questions answered so far.
    var current: Int?
    /// The total number of questions in this session.
    var total: Int?
}
