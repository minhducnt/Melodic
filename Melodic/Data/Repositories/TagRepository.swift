//
//  TagRepository.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation
import NotificationBannerSwift

class TagRepository: ITagRepository {
    // MARK: - Properties

    static let shared = TagRepository() // Singleton instance (optional)

    private init() {} // Prevent instantiation outside of singleton

    // MARK: - Functions

    func getTopArtistsTag(tag: Tag, completion: @escaping (Result<TagTopArtistsResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(
            lastFMMethod: "tag.gettopartists",
            args: ["limit": "6", "tag": tag.name]
        ) { (result: Result<TagTopArtistsResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Failed to load tag artists: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load tag artists",
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
