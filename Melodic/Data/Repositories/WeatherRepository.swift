//
//  WeatherRepository.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Foundation

class WeatherRepository {
    static let shared = WeatherRepository() // Singleton instance (optional)

    private init() {} // Prevent instantiation outside of singleton

    func getWeather(
        city: String,
        appid: String,
        completion: @escaping (Result<WeatherModel, ErrorException>) -> Void
    ) {
        let endpoint = Endpoint.fetchWeather(city: city, appId: appid)

        APIClient.shared.sendRequest(
            endpoint: endpoint,
            responseType: WeatherModel.self
        ) { result in
            switch result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    completion(.success(weatherData))
                }
            case .failure(let error):
                print("Error fetching weather: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(ErrorException.apiError(error.localizedDescription)))
                }
            }
        }
    }
}

