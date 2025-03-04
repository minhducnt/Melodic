//
//  TracksChartView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct TracksChartView: View {
    // MARK: - Properties

    @ObservedObject var viewModel: ChartViewModel
    @Binding var tracksLoaded: Bool

    // MARK: Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.tracks) { track in
                    NavigationLink(
                        destination: TrackScreen(track: track),
                        label: {
                            TrackRow(track: track)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            if !tracksLoaded {
                viewModel.getChartingTracks()
                tracksLoaded = true
            }
            AnalyticsManager.logScreenView(screenName: "TracksChartView")
        }
        .refreshable {
            viewModel.getChartingTracks()
        }
    }
}

#Preview {
    let viewModel: ChartViewModel = .init()
    TracksChartView(
        viewModel: viewModel,
        tracksLoaded: .constant(false)
    )
}
