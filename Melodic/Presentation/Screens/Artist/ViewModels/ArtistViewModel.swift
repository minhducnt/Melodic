//
//  ArtistViewModel.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation
import NotificationBannerSwift

class ArtistViewModel: ObservableObject {
    // MARK: - Properties

    private let artistUsecase: IArtistUsecase

    @Published var albums: [ArtistAlbum] = []
    @Published var tracks: [Track] = []
    @Published var artist: ArtistInfo?

    var isAlbumsLoading = false
    var isTracksLoading = false
    var isInfoLoading = false
    var isLoading = false

    // MARK: - Initial

    init(artistUsecase: IArtistUsecase = ArtistUseCase(repository: ArtistRepository.shared)) {
        self.artistUsecase = artistUsecase
    }

    // MARK: - Functions

    func reset() {
        self.isAlbumsLoading = false
        self.isTracksLoading = false
        self.isInfoLoading = false
    }

    func setIsLoading() {
        if !self.isAlbumsLoading && !self.isTracksLoading && !self.isInfoLoading {
            self.isLoading = true
        }
    }

    func getAll(_ artist: Artist) {
        self.reset()
    }

    // MARK: Get Artist Albums

    func getArtistAlbums(_ artistName: String) {
        self.isLoading = true
        self.albums.removeAll()

        self.artistUsecase.getArtistAlbums(artistName) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.albums = data?.topalbums.album ?? []
                    self.isAlbumsLoading = true
                    for (index, album) in self.albums.enumerated() {
                        SpotifyImage.findImage(type: "album", name: album.name) { [weak self] imageURL in
                            guard let self = self, let imageURL = imageURL, index < self.albums.count else { return }

                            DispatchQueue.main.async {
                                self.albums[index].image[0].url = imageURL
                            }
                        }
                    }
                case .failure(let error):
                    self.isAlbumsLoading = false
                    ErrorHandler.logError(message: "Failed to fetch artist", error: error)
                }
                self.isAlbumsLoading = false
            }
        }

        self.isLoading = false
    }

    // MARK: Get Artist Tracks

    func getArtistTracks(_ artistName: String) {
        self.isLoading = true
        self.tracks.removeAll()

        self.artistUsecase.getArtistTracks(artistName) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.tracks = data?.toptracks.track ?? []
                    self.isTracksLoading = true
                    for (index, track) in self.tracks.enumerated() {
                        SpotifyImage.findImage(type: "track", name: track.name) { [weak self] imageURL in
                            guard let self = self, let imageURL = imageURL, index < self.tracks.count else { return }

                            DispatchQueue.main.async {
                                self.tracks[index].image[0].url = imageURL
                            }
                        }
                    }
                case .failure(let error):
                    self.isTracksLoading = false
                    ErrorHandler.logError(message: "Failed to fetch artist", error: error)
                }
                self.isTracksLoading = false
            }
        }

        self.isLoading = false
    }

    // MARK: Get Artist Info

    func getArtistInfo(_ artistName: String) {
        self.isLoading = true
        self.tracks.removeAll()

        self.artistUsecase.getArtistInfo(artistName) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.artist = data?.artist
                    self.isInfoLoading = true

                    guard let similarArtists = self.artist?.similar.artist else {
                        self.isInfoLoading = false
                        return
                    }

                    for (index, artist) in similarArtists.enumerated() {
                        SpotifyImage.findImage(type: "artist", name: artist.name) { [weak self] imageURL in
                            guard let self = self, let imageURL = imageURL, index < self.artist?.similar.artist.count ?? 0 else { return }
                            
                            DispatchQueue.main.async {
                                self.artist?.similar.artist[index].image[0].url = imageURL
                            }
                        }
                    }

                case .failure(let error):
                    ErrorHandler.logError(message: "Failed to fetch artist info", error: error)
                }

                // Ensure this runs after all async tasks
                self.isInfoLoading = false
                self.isLoading = false
            }
        }
    }

}
