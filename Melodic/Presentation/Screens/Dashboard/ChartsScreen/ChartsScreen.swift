//
//  ChartsView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

// MARK: Main

struct ChartsScreen: View {
    // MARK: - Properties

    @ObservedObject var viewModel: ChartViewModel = .init()

    @State private var selectedChartsIndex: ChartType = .artists
    @State private var artistsLoaded = false
    @State private var tracksLoaded = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack {
                Picker("Charts", selection: self.$selectedChartsIndex) {
                    ForEach(ChartType.allCases) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 8)

                TabView(selection: self.$selectedChartsIndex) {
                    ArtistsChartView(viewModel: self.viewModel, artistsLoaded: self.$artistsLoaded)
                        .tag(ChartType.artists)

                    TracksChartView(viewModel: self.viewModel, tracksLoaded: self.$tracksLoaded)
                        .tag(ChartType.tracks)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Global Charts")
            .frame(maxWidth: .infinity)
            .loader(self.viewModel.isDataLoading)
        }
    }
}

// MARK: Enums

enum ChartType: Int, CaseIterable, Identifiable {
    case artists, tracks

    var id: Int { self.rawValue }

    var title: String {
        switch self {
        case .artists: return "Artists"
        case .tracks: return "Tracks"
        }
    }
}

#Preview {
    ChartsScreen()
}
