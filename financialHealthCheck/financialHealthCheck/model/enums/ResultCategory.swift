//
//  ResultCategory.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Foundation

/// The band a completed session's score falls into, returned in `ResultDTO.category`.
///
/// Usage: `Strings.Result.title(for:)`/`description(for:)` map this to the copy shown on
/// `ResultView`.
enum ResultCategory: String, Codable {
    case poor
    case fair
    case good
    case excellent
}
