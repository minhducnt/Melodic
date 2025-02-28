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
    let headers: [String: String]
    let body: Data?

    var url: URL? {
        return URL(string: "\(ServerConfig.BASE_URL.absoluteString)\(path)")
    }
}
