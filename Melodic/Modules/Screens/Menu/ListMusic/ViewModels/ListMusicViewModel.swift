//
//  ListMusicViewModel.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    // MARK: - Properties

    @Published var weatherData: [WeatherModel] = []
    @Published var isDataLoading = false
    @Published var selectedCardIndex = 0
    @Published var apiError: AppError?

    let cities = ["Vietnam", "Delhi", "Jaipur", "Mumbai", "Chennai", "Bengaluru", "Kolkata"]

    // MARK: - Functions

    func getWeatherData() {
        isDataLoading = true
        weatherData.removeAll()

        let dispatchGroup = DispatchGroup() // Used to track multiple API calls

        for city in cities {
            dispatchGroup.enter() // Track each API call

            WeatherRepository.shared.getWeather(city: city, appid: Constants.weatherAppId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self?.weatherData.append(weather)
                    case .failure(let error):
                        self?.apiError = error as? AppError
                        ErrorHandler.logError(message: "Failed to fetch weather for \(city)", error: error)
                    }
                    dispatchGroup.leave() // Mark this API call as complete
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.isDataLoading = false // Only stop loading when all API calls are done
        }
    }

    func conditionImage(conditionId: Int) -> String {
        switch conditionId {
        case 200 ... 232:
            return "cloud.bolt"
        case 300 ... 321:
            return "cloud.drizzle"
        case 500 ... 531:
            return "cloud.rain"
        case 600 ... 622:
            return "cloud.snow"
        case 701 ... 781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801 ... 804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

    func conditionColor(conditionId: Int) -> Color {
        switch conditionId {
        case 200 ... 232:
            return .purple // Thunderstorm
        case 300 ... 321:
            return .blue // Drizzle
        case 500 ... 531:
            return .blue.opacity(0.8) // Rain
        case 600 ... 622:
            return .teal // Snow
        case 701 ... 781:
            return .gray // Atmosphere
        case 800:
            return .yellow // Clear
        case 801 ... 804:
            return .gray.opacity(0.7) // Clouds
        default:
            return .indigo
        }
    }
}
