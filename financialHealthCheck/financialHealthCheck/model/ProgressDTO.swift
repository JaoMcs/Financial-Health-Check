//
//  ProgressDTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// How far along the session is, returned alongside every question or result.
struct ProgressDTO: DTO {
    /// The number of questions answered so far.
    var current: Int?
    /// The total number of questions in this session.
    var total: Int?
}
