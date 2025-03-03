//
//  MelodicApp.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import FirebaseCore
import SwiftUI
import LastFM

// MARK: - Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct melodicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootCoordinator()
        }
    }
}
