//
//  KeyChainStorage.swift
//  Melodic
//
//  Created by TMA on 26/2/25.
//

import Foundation
import KeychainSwift

class KeyChainStorage {
    static let shared = KeyChainStorage()

    private init() {}

    // MARK: - Properties

    private let keychainInstance = KeychainSwift()

    private let AUTH_TOKEN: String = "AUTH_TOKEN"
    private let PASSWORD: String = "PASSWORD"

    // MARK: - Functions

    func setAuthToken(_ value: String) -> Bool {
        return keychainInstance.set(value, forKey: AUTH_TOKEN)
    }

    func getAuthToken() -> String? {
        keychainInstance.get(AUTH_TOKEN)
    }

    func setPassword(_ value: String) {
        keychainInstance.set(value, forKey: PASSWORD)
    }

    func getPassword() -> String {
        keychainInstance.get(PASSWORD)!
    }

    func deleteAllKey() {
        keychainInstance.delete(AUTH_TOKEN)
        keychainInstance.delete(PASSWORD)
    }
}
