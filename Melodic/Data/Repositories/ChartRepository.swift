//
//  ChartRepository.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Foundation
import NotificationBannerSwift

class ChartRepository: IChartRepository {
    // MARK: - Properties

    static let shared = ChartRepository() // Singleton instance (optional)

    private init() {} // Prevent instantiation outside of singleton

    // MARK: - Functions

    func getChartingArtists(completion: @escaping (Result<TopArtistsResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(lastFMMethod: "chart.gettopartists", args: ["limit": "30"]) { (result: Result<TopArtistsResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Error fetching charting artists: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load top artists",
                        subtitle: error.localeDes,
                        style: .danger).show()

                    // MARK: Return failure

                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }

    func getChartingTracks(completion: @escaping (Result<TopTrackResponse?, ErrorException>) -> Void) {
        LastFMAPI.shared.sendRequest(lastFMMethod: "chart.gettoptracks", args: ["limit": "30"]) { (result: Result<TopTrackResponse, ErrorException>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                ErrorHandler.logError(message: "Error fetching charting artists: \(error)", error: error)
                DispatchQueue.main.async {
                    // MARK: Show notification

                    FloatingNotificationBanner(
                        title: "Failed to load top tracks",
                        subtitle: error.localeDes,
                        style: .danger).show()

                    // MARK: Return failure

                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }
}
