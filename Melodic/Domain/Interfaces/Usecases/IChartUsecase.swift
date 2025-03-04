//
//  IChartUsecase.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

protocol IChartUsecase {
    func getChartingArtists(completion: @escaping (Result<TopArtistsResponse?, ErrorException>) -> Void)
    func getChartingTracks(completion: @escaping (Result<TopTrackResponse?, ErrorException>) -> Void)
}
