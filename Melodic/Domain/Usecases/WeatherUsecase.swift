//
//  WeatherUsecase.swift
//  Melodic
//
//  Created by Admin on 3/3/25.
//

import Foundation

class FetchWeatherUseCase : IWeatherUsecase {
    // MARK: - Properties

    private let repository: IWeatherRepository

    init(repository: IWeatherRepository) {
        self.repository = repository
    }

    // MARK: - Functions

    func execute(
        city: String,
        appid: String,
        completion: @escaping (Result<WeatherModel, ErrorException>) -> Void
    ) {
        // Kiểm tra dữ liệu đầu vào (logic nghiệp vụ)
        guard !city.isEmpty else {
            completion(.failure(ErrorException.apiError("City name cannot be empty")))
            return
        }

        // Gọi Repository để lấy dữ liệu thời tiết
        repository.getWeather(city: city, appid: appid, completion: completion)
    }
}
