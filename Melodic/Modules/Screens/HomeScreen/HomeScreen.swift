//
//  ContentView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct HomeScreen: View {
    // MARK: - Properties

    @StateObject var viewModel: MainTabViewModel = .init()

    // MARK: - Body

    var body: some View {
        MainTabView(viewModel: viewModel)
    }
}

#Preview {
    HomeScreen()
}
