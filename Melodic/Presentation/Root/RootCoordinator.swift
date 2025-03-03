//
//  RootCoordinator.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct RootCoordinator: View {
    // MARK: - Properties

    enum Root {
        case splash
        case mainApp
    }

    @State private var root: Root = .splash

    // MARK: - Managers

    @ObservedObject private var rootViewModel = RootViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            switch root {
            case .splash:
                SplashScreen()
                    .onAppear {
                        appStart()
                    }

            case .mainApp:
                HomeScreen()
            }
        }

        .onChange(of: rootViewModel.isAppStartCompleted) { _, _ in updateRoot() }
    }

    // MARK: - Functions

    private func appStart() {
        Task { @MainActor in
            do {
                try await rootViewModel.start()
            } catch {
                ErrorHandler.logError(message: "Error while starting app", error: error)
            }
        }
    }

    private func updateRoot() {
        if !rootViewModel.isAppStartCompleted {
            root = .splash
        } else {
            root = .mainApp
        }
    }
}

#Preview {
    RootCoordinator()
}
