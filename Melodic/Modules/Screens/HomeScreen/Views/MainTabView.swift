//
//  MainTabView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - Properties

    @ObservedObject var viewModel: MainTabViewModel

    // MARK: - Body

    var body: some View {
        TabView(
            selection: $viewModel.selectedTab,
            content: {
                ListMusicView().tabItem {
                    TabItemView(
                        title: "Home",
                        icon: "house.fill"
                    )
                }.tag(Tab.tab1)

                ListFavoriteView().tabItem {
                    TabItemView(
                        title: "Favorite",
                        icon: "heart.fill"
                    )
                }.tag(Tab.tab2)
            }
        )
        .accentColor(.primarySof)
        .onAppear {
            withAnimation {
                UITabBar.appearance().unselectedItemTintColor = UIColor(.gray.opacity(0.5))
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    if horizontalAmount < -50 {
                        viewModel.switchToNextTab()
                    } else if horizontalAmount > 50 {
                        viewModel.switchToPreviousTab()
                    }
                }
        )
    }
}

#Preview {
    let viewModel = MainTabViewModel()
    MainTabView(
        viewModel: viewModel
    )
}
