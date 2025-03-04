//
//  TagViewModel.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation
import NotificationBannerSwift

class TagViewModel: ObservableObject {
    // MARK: - Properties

    private let tagUsecase: ITagUsecase

    @Published var artists: [Artist] = []
    @Published var isLoading = false

    // MARK: - Initial

    init(tagUsecase: ITagUsecase = TagUseCase(repository: TagRepository.shared)) {
        self.tagUsecase = tagUsecase
    }

    // MARK: - Body

    func getTopArtists(tag: Tag) {
        isLoading = true

        tagUsecase.getTopArtistsTag(tag: tag) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    var artists = data?.topartists.artist ?? []
                    for (index, artist) in artists.enumerated() {
                        SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                            if let imageURL = imageURL {
                                DispatchQueue.main.async {
                                    artists[index].image[0].url = imageURL
                                }
                            }
                        }
                    }
                    self?.artists = artists
                case .failure(let error):
                    ErrorHandler.logError(message: "Failed to fetch artist", error: error)
                }
            }
        }

        isLoading = false
    }
}
