//
//  TopArtistTracksView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct TopArtistTracksView: View {
    // MARK: - Properties

    var tracks: [Track]

    // MARK: - Body

    var body: some View {
        List {
            Section {
                Text("Top tracks")
                    .font(.headline)
                    .unredacted()
                
                if !tracks.isEmpty {
                    ForEach(tracks, id: \.name) { track in
                        NavigationLink(
                            destination: TrackScreen(track: track),
                            label: {
                                TrackRow(track: track)
                            }
                        )
                    }
                } else {
                    ForEach(1 ... 5, id: \.self) { _ in
                        NavigationLink(
                            destination: Color(.red),
                            label: {
                                TrackRow(
                                    track: Track(
                                        name: "toto",
                                        playcount: "123",
                                        listeners: "123",
                                        url: "123",
                                        artist: nil,
                                        image: [
                                            LastFMImage(url: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp", size: "large")
                                        ]
                                    )
                                )
                            }
                        )
                    }
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 5, trailing: 16))
        .hasScrollEnabled(false)
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let tracks: [Track] = [Track.fixture()]
    TopArtistTracksView(tracks: tracks)
}
