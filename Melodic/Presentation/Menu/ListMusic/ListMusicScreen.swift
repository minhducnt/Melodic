//
//  ListMusicView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct ListMusicScreen: View {
    // MARK: - Properties

    @StateObject var viewModel: WeatherViewModel = .init()

    // MARK: - Body

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if !viewModel.isDataLoading {
                        ForEach(viewModel.weatherData, id: \.self) { data in
                            CardView(
                                title: data.name,
                                subTitle: "",
                                conditionImage: viewModel.conditionImage(conditionId: data.id),
                                conditionColor: viewModel.conditionColor(conditionId: data.id)
                            )
                            .onTapGesture {
                                viewModel.selectedCardIndex = viewModel.weatherData.firstIndex(of: data)!
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.apiError != nil },
                set: { _ in viewModel.apiError = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.apiError?.message ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .frame(maxWidth: .infinity)
        .loader(viewModel.isDataLoading)
        .onAppear {
            viewModel.getWeatherData()
            AnalyticsManager.logScreenView(screenName: String(describing: Self.self))
        }
    }
}

#Preview {
    ListMusicScreen()
}
