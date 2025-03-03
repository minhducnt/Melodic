//
//  LastFMAPIClient.swift
//  Melodic
//
//  Created by Admin on 3/3/25.
//

import Alamofire
import CryptoSwift
import Foundation
import os

class LastFMAPI {
    static let shared = LastFMAPI()

    // MARK: - Logger

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LastFMAPI.self)
    )

    // MARK: - Functions

    static func request<T: Decodable>(
        method: HTTPMethod = .post,
        lastFMMethod: String,
        args: [String: String] = [:],
        completion: @escaping (Result<T, ErrorException>) -> Void
    ) {
        // MARK: - Setup Client

        // Construct Args
        var fullArgs = args
        fullArgs["method"] = lastFMMethod
        fullArgs["api_key"] = AppConfig.lastFMAPIKey

        // Validate and construct URL
        let signature = fullArgs.sorted(by: { $0.key < $1.key }).reduce("") { $0 + $1.key + $1.value } + AppConfig.lastFMSharedSecret
        fullArgs["api_sig"] = signature.md5()
        fullArgs["format"] = "json"

        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/x-www-form-urlencoded")

        let url = AppConfig.baseURL.absoluteString

        // MARK: - Network request

        logger.info("Sending request with args: \(fullArgs)")

        AF.request(
            url,
            method: method,
            parameters: fullArgs,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                logger.error("Request failed for \(lastFMMethod): \(error.localizedDescription)")

                if let responseData = response.data, let httpResponse = response.response, httpResponse.statusCode == 400, lastFMMethod == "user.getFriends" {
                    // Handle specific error case
                    if let friendsResponse = try? JSONDecoder().decode(FriendsResponse.self, from: responseData), let castedResponse = friendsResponse as? T {
                        completion(.success(castedResponse))
                    } else {
                        completion(.failure(ErrorException.genericError))
                    }
                    return
                }

                completion(.failure(ErrorException.apiError("Invalid last.fm API response 😢. Please try again")))
            }
        }
    }
}
