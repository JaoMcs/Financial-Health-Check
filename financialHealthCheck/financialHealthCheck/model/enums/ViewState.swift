//
//  ViewState.swift
//  financialHealthCheck
//
//  Created by Joao on 18/08/26.
//

import Foundation

/// The state a screen's ViewModel is in while it loads data from a `HealthCheckRepositoring`
/// call — drives which of loading/content/error the View renders.
///
/// Usage: `@Published var state: ViewState = .loading`, then `switch state { case .loading:
/// ProgressView(); case .content: ...; case .error(let error): ... }`.
enum ViewState: Equatable {
    /// A request is in flight — nothing to render yet.
    case loading
    /// The request succeeded — the screen's data is ready to render.
    case content
    /// The request failed.
    case error(NetworkError)

    /// Whether this is `.loading` — e.g. `AppButton(isLoading: viewModel.state.isLoading, ...)`.
    var isLoading: Bool {
        switch self {
        case .loading: true
        case .content, .error: false
        }
    }
}
