//
//  Coordinator.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Foundation

/// A flow's entry point and navigation owner (MVVM-C, per `CLAUDE.md`). Each screen's
/// View/ViewModel pair belongs to exactly one `Coordinator`, responsible for pushing it and
/// creating/starting whatever comes next.
protocol Coordinator: AnyObject {
    /// Begins this flow — pushes its first screen, or hands off to a child coordinator.
    func start()
}
