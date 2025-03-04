//
//  IArtistRepository.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

protocol IArtistRepository {
    func getArtistAlbums(_ artistName: String, completion: @escaping (Result<ArtistTopAlbumsResponse?, ErrorException>) -> Void)
    func getArtistTracks(_ artistName: String, completion: @escaping (Result<ArtistTopTracksResponse?, ErrorException>) -> Void)
    func getArtistInfo(_ artistName: String, completion: @escaping (Result<ArtistInfoResponse?, ErrorException>) -> Void)
}
