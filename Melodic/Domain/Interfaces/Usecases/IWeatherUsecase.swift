//
//  WeatherInterface.swift
//  Melodic
//
//  Created by Admin on 3/3/25.
//

import Foundation

protocol IWeatherUsecase {
    func execute(
        city: String,
        appid: String,
        completion: @escaping (Result<WeatherModel, ErrorException>) -> Void)
}
