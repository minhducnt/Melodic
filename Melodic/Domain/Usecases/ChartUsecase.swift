//
//  ChartUsecase.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

class ChartUseCase: IChartUsecase {
    // MARK: - Properties
    
    private let repository: IChartRepository
    
    init(repository: IChartRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func getChartingArtists(completion: @escaping (Result<TopArtistsResponse?, ErrorException>) -> Void) {
        repository.getChartingArtists(completion: completion)
    }
    func getChartingTracks(completion: @escaping (Result<TopTrackResponse?, ErrorException>) -> Void) {
        repository.getChartingTracks(completion: completion)
    }
}
