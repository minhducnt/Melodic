//
//  ArtistUsecase.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

class ArtistUseCase: IArtistUsecase {
    // MARK: - Properties
    
    private let repository: IArtistRepository
    
    init(repository: IArtistRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func getArtistAlbums(_ artistName: String, completion: @escaping (Result<ArtistTopAlbumsResponse?, ErrorException>) -> Void) {
        repository.getArtistAlbums(artistName, completion: completion)
    }
    
    func getArtistTracks(_ artistName: String, completion: @escaping (Result<ArtistTopTracksResponse?, ErrorException>) -> Void) {
        repository.getArtistTracks(artistName, completion: completion)
    }
    
    func getArtistInfo(_ artistName: String, completion: @escaping (Result<ArtistInfoResponse?, ErrorException>) -> Void) {
        repository.getArtistInfo(artistName, completion: completion)
    }
}
