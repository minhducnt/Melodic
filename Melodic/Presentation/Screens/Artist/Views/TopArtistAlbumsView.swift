//
//  TopArtistAlbumsView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Kingfisher
import SwiftUI

struct TopArtistAlbumsView: View {
    // MARK: - Properties

    var albums: [ArtistAlbum]

    // MARK: - Body

    var body: some View {
        Section {
            Text("Top albums").font(.headline)
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 50, maximum: 200)),
                GridItem(.flexible(minimum: 50, maximum: 200))
            ], spacing: 30) {
                if !albums.isEmpty {
                    ForEach(albums, id: \.name) { album in
                        NavigationLink(
                            destination: AlbumScreen(album: album),
                            label: {
                                VStack {
                                    KFImage.url(URL(string: !album.image[0].url.isEmpty ? album.image[0].url : LastFMImage.fixture().url))
                                        .resizable()
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                    Text(album.name).font(.headline).lineLimit(1).foregroundColor(.white)
                                    Text("\(Int(exactly: album.playcount)?.formatted() ?? "0") scrobbles")
                                        .font(.subheadline)
                                        .foregroundColor(.gray).lineLimit(1)
                                }
                            }
                        )
                    }
                } else {
                    // Placeholder for redacted
                    ForEach(1 ... 6, id: \.self) { _ in
                        NavigationLink(
                            destination: Color(.red),
                            label: {
                                VStack {
                                    KFImage.url(URL(string: "https://lastfm.freetls.fastly.net/i/u/64s/4128a6eb29f94943c9d206c08e625904.webp")!)
                                        .resizable()
                                        .cornerRadius(5)
                                        .aspectRatio(contentMode: .fill)
                                    Text("Album name").font(.headline).lineLimit(1).foregroundColor(.white)
                                    Text("\(String(format: "%ld", locale: Locale.current, 0)) listeners")
                                        .font(.subheadline)
                                        .foregroundColor(.gray).lineLimit(1)
                                }
                            }
                        )
                    }
                }
            }
        }
        .padding()
    }
}
