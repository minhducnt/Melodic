//
//  ArtistRow.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Kingfisher
import os
import SwiftUI

struct ArtistRow: View {
    // MARK: - Properties

    var artist: Artist

    // MARK: - Body

    var body: some View {
        HStack {
            // MARK: Image

            KFImage.url(URL(string: artist.image[0].url)!)
                .resizable()
                .onFailure { err in
                    ErrorHandler.logError(
                        message: "Error while loading artist image \(artist.name)",
                        error: err
                    )
                }
                .placeholder {
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                }
                .fade(duration: 0.5)
                .cancelOnDisappear(true)
                .cornerRadius(5)
                .frame(width: 80, height: 80)
                .padding(.trailing, 9)

            // MARK: Info

            VStack(alignment: .leading) {
                Spacer()
                Text(artist.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(artist.listeners ?? "0")?.formatted() ?? "0") listeners")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .frame(height: 80)
    }
}

#Preview("ArtistRow", traits: .sizeThatFitsLayout) {
    let artist = Artist.fixture()
    ArtistRow(artist: artist)
}

#Preview("Fullview", traits: .sizeThatFitsLayout) {
    ChartsScreen()
}
