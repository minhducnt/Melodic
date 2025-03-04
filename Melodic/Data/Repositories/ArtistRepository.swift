//
//  ArtistRepository.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation
import NotificationBannerSwift

class ArtistRepository: IArtistRepository {
    // MARK: - Properties

    static let shared = ArtistRepository() // Singleton instance (optional)

    private init() {} // Prevent instantiation outside of singleton

    // MARK: - Functions

    func getArtistAlbums(_ artistName: String, completion: @escaping (Result<ArtistTopAlbumsResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(
            lastFMMethod: "artist.gettopalbums",
            args: ["limit": "6", "artist": artistName]
        ) { (result: Result<ArtistTopAlbumsResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Failed to load albums: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load albums",
                        subtitle: error.localeDes,
                        style: .danger
                    ).show()

                    // MARK: Return failure

                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }

    func getArtistTracks(_ artistName: String, completion: @escaping (Result<ArtistTopTracksResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(
            lastFMMethod: "artist.gettoptracks",
            args: ["limit": "6", "artist": artistName]
        ) { (result: Result<ArtistTopTracksResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Failed to load tracks: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load tracks",
                        subtitle: error.localeDes,
                        style: .danger
                    ).show()

                    // MARK: Return failure

                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }

    func getArtistInfo(_ artistName: String, completion: @escaping (Result<ArtistInfoResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(
            lastFMMethod: "artist.getinfo",
            args: ["limit": "6", "artist": artistName]
        ) { (result: Result<ArtistInfoResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Failed to load albums: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load albums",
                        subtitle: error.localeDes,
                        style: .danger
                    ).show()

                    // MARK: Return failure

                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }
}
