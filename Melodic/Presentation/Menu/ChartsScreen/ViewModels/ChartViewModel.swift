//
//  ChartsViewModel.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation

class ChartViewModel: ObservableObject {
    // MARK: Properties
    
    private let chartUsecase: IChartUsecase
    
    @Published var artists: [Artist] = []
    @Published var tracks: [Track] = []
    @Published var isDataLoading = false
    
    // MARK: - Initial

    init(chartUsecase: IChartUsecase = ChartUseCase(repository: ChartRepository.shared)) {
        self.chartUsecase = chartUsecase
    }
    
    // MARK: Get Top Artists Chart
        
    func getChartingArtists() {
        isDataLoading = true
        
        artists.removeAll()
        
        chartUsecase.getChartingArtists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    var artists = data?.artists.artist ?? []
                    for (index, artist) in artists.enumerated() {
                        SpotifyImage.findImage(type: "artist", name: artist.name) { imageURL in
                            if let imageURL = imageURL {
                                artists[index].image[0].url = imageURL
                            }
                        }
                    }
                    self?.artists = artists
                case .failure(let error):
                    ErrorHandler.logError(message: "Failed to fetch artist", error: error)
                }
            }
        }
        
        isDataLoading = false
    }

    // MARK: Get Top Tracks Chart
    
    func getChartingTracks() {
        isDataLoading = true
        
        tracks.removeAll()
        
        chartUsecase.getChartingTracks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    var tracks = data?.tracks.track ?? []
                    for (index, track) in tracks.enumerated() {
                        SpotifyImage.findImage(type: "track", name: track.name) { imageURL in
                            if let imageURL = imageURL {
                                tracks[index].image[0].url = imageURL
                            }
                        }
                    }
                    self?.tracks = tracks
                case .failure(let error):
                    ErrorHandler.logError(message: "Failed to fetch artist", error: error)
                }
            }
        }
        
        isDataLoading = false
    }
}
