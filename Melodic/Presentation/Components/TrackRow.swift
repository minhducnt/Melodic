//
//  TrackRow.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Kingfisher
import SwiftUI

struct TrackRow: View {
    // MARK: - Properties

    var track: Track

    // MARK: - Body

    var body: some View {
        HStack {
            KFImage.url(URL(string: track.image[0].url)!)
                .resizable()
                .onFailure { err in
                    ErrorHandler.logError(
                        message: "Error \(self.track.name): \(err)",
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
                .padding(.trailing, 5)

            VStack(alignment: .leading) {
                Spacer()
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(track.playcount)?.formatted() ?? "0") scrobbles")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .frame(height: 80)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let track = Track.fixture()
    TrackRow(track: track)
}
