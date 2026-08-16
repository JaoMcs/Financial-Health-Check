//
//  StartViewModel.swift
//  financialHealthCheck
//
//  Created by Joao on 15/08/26.
//

import Combine

/// `StartView`'s view model. `ObservableObject` for consistency with every other
/// ViewModel — no `@Published` state yet, but this is the shape every screen's ViewModel
/// follows.
final class StartViewModel: ObservableObject {
    /// Called when the user taps "Start". Set by `StartCoordinator` — empty for now.
    var onStartTapped: (() -> Void) = {}

    func startTapped() {
        onStartTapped()
    }
}
