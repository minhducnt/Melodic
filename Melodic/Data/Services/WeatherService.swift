//
//  WeatherService.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

extension Endpoint {
    static func fetchWeather(city: String, appId: String) -> Endpoint {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: appId)
        ]
        let bodyData = components.query?.data(using: .utf8 )
        return Endpoint(
            path: "/data/2.5/weather",
            method: .get,
            headers: [:],
            body: bodyData
        )
    }
}
