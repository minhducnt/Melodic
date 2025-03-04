//
//  ArtistsChartView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct ArtistsChartView: View {
    // MARK: - Properties

    @ObservedObject var viewModel: ChartViewModel
    @Binding var artistsLoaded: Bool

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.artists) { artist in
                    NavigationLink(
                        destination: ArtistScreen(artist: artist),
                        label: {
                            ArtistRow(artist: artist)
                        }
                    )                                    }
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            if !artistsLoaded {
                viewModel.getChartingArtists()
                artistsLoaded = true
            }
            AnalyticsManager.logScreenView(screenName: "ArtistsChartView")
        }
        .refreshable {
            viewModel.getChartingArtists()
        }
    }
}

#Preview {
    let viewModel: ChartViewModel = .init()
    ArtistsChartView(
        viewModel: viewModel,
        artistsLoaded: .constant(false)
    )
}
