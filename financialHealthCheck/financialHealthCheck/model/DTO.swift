//
//  DTO.swift
//  financialHealthCheck
//
//  Created by Joao on 12/08/26.
//

import Foundation

/// Marker protocol for the API's Data Transfer Objects.
///
/// Conforming to `DTO` means a type is `Codable` and represents the exact JSON shape
/// exchanged with the `health-check` API, as opposed to a type used only inside the app.
protocol DTO: Codable {}
