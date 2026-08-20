//
//  NavigationHostingController.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import SwiftUI
import UIKit

/// Hosts a SwiftUI screen as a child view controller and installs a `NavigationHeader` on
/// itself, so a coordinator gets both steps in one call when it pushes a screen.
///
/// - Parameters:
///   - rootView: The SwiftUI screen to host.
///   - title: Forwarded to `NavigationHeader`.
///   - current: Forwarded to `NavigationHeader`.
///   - total: Forwarded to `NavigationHeader`. `0` (the default) hides the progress bar.
final class NavigationHostingController<Content: View>: UIViewController {
    private let hostingController: UIHostingController<Content>
    private let headerTitle: String
    private let headerCurrent: Int
    private let headerTotal: Int

    init(rootView: Content, title: String, current: Int = 0, total: Int = 0) {
        self.hostingController = UIHostingController(rootView: rootView)
        self.headerTitle = title
        self.headerCurrent = current
        self.headerTotal = total
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        embedHostingController()
        NavigationHeader.install(title: headerTitle, current: headerCurrent, total: headerTotal, on: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHeader.styleBackButton(on: navigationController)
    }

    /// Adds `hostingController` as a child, filling this controller's `view` edge to edge.
    private func embedHostingController() {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
