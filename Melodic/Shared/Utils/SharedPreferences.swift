//
//  SharedPreferences.swift
//  Melodic
//
//  Created by TMA on 26/2/25.
//

import Foundation

class SharedPreferences {
    // MARK: - Properties

    static let shared = SharedPreferences()

    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Setup Keys

    enum Keys {
        static let isAuthenticated = "isAuthenticated"
        static let isOnboardingCompleted = "isOnboardingCompleted"
        static let selectedTheme = "selectedTheme"
    }

    // MARK: - Functions

    var isAuthenticated: Bool {
        set {
            defaults.setValue(newValue, forKey: Keys.isAuthenticated)
        }
        get {
            return defaults.bool(forKey: Keys.isAuthenticated)
        }
    }

    var isOnboardingCompleted: Bool {
        set {
            defaults.setValue(newValue, forKey: Keys.isOnboardingCompleted)
        }
        get {
            return defaults.bool(forKey: Keys.isOnboardingCompleted)
        }
    }

    var selectedAppearance: String {
        set {
            defaults.setValue(newValue, forKey: Keys.selectedTheme)
        }
        get {
            return defaults.string(forKey: Keys.selectedTheme)
                ?? Theme.light.rawValue
        }
    }
}
