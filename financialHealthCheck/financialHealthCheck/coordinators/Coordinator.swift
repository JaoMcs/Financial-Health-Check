//
//  Coordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// A flow's entry point and navigation owner (MVVM-C, per `CLAUDE.md`).
protocol Coordinator: AnyObject {
    /// Begins this flow.
    func start()
}
