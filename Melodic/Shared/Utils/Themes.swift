//
//  Themes.swift
//  Melodic
//
//  Created by TMA on 26/2/25.
//

import Foundation
import SwiftUI

// MARK: - Theme (Dark/Light)

enum Theme: String {
    case light, dark
}

// MARK: - Preferences

enum Preferences {
    // MARK: - Get the current theme

    static var themeMode: Theme {
        get {
            let storedValue = SharedPreferences.shared.selectedAppearance
            return Theme(rawValue: storedValue) ?? .light
        }
        set {
            SharedPreferences.shared.selectedAppearance = newValue.rawValue
            applyTheme(newValue)
        }
    }

    // MARK: - Change the theme

    static func applyTheme(_ mode: Theme) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    switch mode {
                    case .light:
                        window.overrideUserInterfaceStyle = .light
                    case .dark:
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            }
        }
    }
}
