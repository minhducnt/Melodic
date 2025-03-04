//
//  ITagUsecase.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

protocol ITagUsecase {
    func getTopArtistsTag(tag: Tag, completion: @escaping (Result<TagTopArtistsResponse?, ErrorException>) -> Void)
}
