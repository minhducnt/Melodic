//
//  Endpoint.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let queryItems: [URLQueryItem]?
    let body: Data?

    var url: URL? {
        var components = URLComponents(string: "\(AppConfig.baseURL.absoluteString)\(path)")
        components?.queryItems = queryItems
        return components?.url
    }
}

extension Endpoint {
    // MARK: - Weather Endpoints

    static func fetchWeather(city: String, appId: String) -> Endpoint {
        return Endpoint(
            path: "/data/2.5/weather",
            method: .get,
            headers: [:],
            queryItems: [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: appId)
            ],
            body: nil
        )
    }
}
