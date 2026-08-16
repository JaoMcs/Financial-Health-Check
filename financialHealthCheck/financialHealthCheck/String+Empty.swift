//
//  String+Empty.swift
//  financialHealthCheck
//
//  Created by Joao on 16/08/26.
//

import Foundation

extension Optional where Wrapped == String {
    /// Whether this is `nil`, empty, or made up entirely of whitespace.
    var isNilOrEmpty: Bool {
        (self ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
