//
//  WeatherRepositoryProtocol.swift
//  Melodic
//
//  Created by Admin on 3/3/25.
//

import Foundation

protocol IWeatherRepository {
    func getWeather(
        city: String,
        appid: String,
        completion: @escaping (Result<WeatherModel, ErrorException>) -> Void
    )
}
