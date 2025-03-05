//
//  ArtistInfoView.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct ArtistInfoView: View {
    // MARK: - Properties

    var artistInfo: ArtistInfo?
    var artist: Artist

    // MARK: - Body

    var body: some View {
        HStack {
            Text("\(Int((artistInfo?.stats.playcount) ?? "0")?.formatted() ?? "0") scrobbles")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("\(Int((artistInfo?.stats.listeners) ?? "0")?.formatted() ?? "0") listeners")
                .font(.subheadline)
                .foregroundColor(.gray)
        }

        NavigationLink(destination: ArtistBioView(artistInfo: artistInfo)) {
            VStack(alignment: .leading) {
                Text(artistInfo?.bio.content ?? "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.")
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }
        }

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let artistInfo = artistInfo {
                    ForEach(artistInfo.tags.tag, id: \.name) { tag in
                        NavigationLink(
                            destination: TagScreen(tag: tag),
                            label: {
                                Text(tag.name)
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                                    .cornerRadius(.infinity)
                                    .lineLimit(1)
                            })
                    }
                } else {
                    ForEach(["pop", "synthpop", "female vocalist", "indie"], id: \.self) { tag in
                        Text(tag)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(.infinity)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
