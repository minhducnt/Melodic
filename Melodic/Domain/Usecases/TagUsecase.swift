//
//  TagUsecase.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

class TagUseCase: ITagUsecase {
    // MARK: - Properties

    private let repository: ITagRepository

    init(repository: ITagRepository) {
        self.repository = repository
    }

    // MARK: - Functions

    func getTopArtistsTag(tag: Tag, completion: @escaping (Result<TagTopArtistsResponse?, ErrorException>) -> Void) {
        repository.getTopArtistsTag(tag: tag, completion: completion)
    }
}
