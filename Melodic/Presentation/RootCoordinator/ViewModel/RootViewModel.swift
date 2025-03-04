//
//  RootViewModel.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Foundation

@MainActor
class RootViewModel: ObservableObject {
    // MARK: - Attributes

    @Published var isAppStartCompleted: Bool = false

    // MARK: - Functions

    func start() async throws {
        guard !isAppStartCompleted else { return }

        // All starting set up will be done here
        // testing load time 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(2 * 1000))) {
            self.isAppStartCompleted = true
        }
    }
}
