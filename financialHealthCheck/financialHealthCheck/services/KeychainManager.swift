//
//  KeychainManager.swift
//  financialHealthCheck
//
//  Created by Joao on 13/08/26.
//

import Foundation
import Security

/// Owns storing and retrieving the health-check session id in the device Keychain.
///
/// The session id is a client-generated UUID string with no accompanying metadata, so it is
/// persisted as-is (UTF-8 encoded) rather than wrapped in a structured payload. No other part
/// of the app should talk to the Keychain directly — go through this type instead.
enum KeychainManager {
    private static let service = "com.financialHealthCheck.session"
    private static let account = "sessionId"

    /// Persists `sessionId`, replacing any value already stored.
    static func save(_ sessionId: String) {
        guard let data = sessionId.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        SecItemAdd(attributes as CFDictionary, nil)
    }

    /// Returns the stored session id, or `nil` if none has been saved yet — signaling that no
    /// health-check session has been started on this device.
    static func load() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let sessionId = String(data: data, encoding: .utf8) else {
            return nil
        }

        return sessionId
    }

    /// Removes the stored session id, if any. Used to clear the session on logout.
    static func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
