//
//  ArtistScreen.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import FancyScrollView
import Kingfisher
import SwiftUI

struct ArtistScreen: View {
    // MARK: - Properties

    let artist: Artist

    @ObservedObject var viewModel: ArtistViewModel = .init()

    // MARK: - Body

    var body: some View {
        ZStack {
            GeometryReader { g in
                FancyScrollView(
                    title: artist.name,
                    headerHeight: 350,
                    scrollUpHeaderBehavior: .parallax,
                    scrollDownHeaderBehavior: .offset,
                    header: {
                        KFImage.url(URL(string: artist.image[0].url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                ) {
                    VStack(alignment: .leading) {
                        ArtistInfoView(artistInfo: viewModel.artist, artist: artist)
                            .padding()
                            .redacted(reason: viewModel.artist == nil ? .placeholder : [])

                        TopArtistTracksView(tracks: viewModel.tracks)
                            .frame(
                                width: g.size.width - 5,
                                height: g.size.height * 0.7,
                                alignment: .center
                            )
                            .redacted(reason: viewModel.tracks.isEmpty ? .placeholder : [])

                        TopArtistAlbumsView(albums: viewModel.albums).offset(y: -50)
                            .redacted(reason: viewModel.albums.isEmpty ? .placeholder : [])

                        SimilarArtistsView(similarArtists: viewModel.artist?.similar.artist ?? [])
                            .offset(y: -30)
                            .redacted(reason: viewModel.artist == nil ? .placeholder : [])
                    }
                    .padding(.top, 10)
                    .onLoad {
                        viewModel.getAll(artist)
                    }
                }
                .navigationTitle(artist.name)
            }
        }
    }
}

#Preview {
    let artist = Artist.fixture()
    ArtistScreen(artist: artist)
}
