//
//  SpotifyAPIClient.swift
//  Melodic
//
//  Created by Admin on 4/3/25.
//

import Alamofire
import os
import SwiftUI

class SpotifyAPI {
    // MARK: - Properties

    static let shared = SpotifyAPI()

    @AppStorage("spotify_tmp_token") var spotifyToken: String?
    @AppStorage("spotify_expires_at") var spotifyExpiresAt: String?

    // MARK: - Logger

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LastFMAPI.self)
    )

    // MARK: Renew Spotify Token

    func renewSpotifyToken(completion: @escaping (String) -> Void) {
        let authURL = "https://accounts.spotify.com/api/token"

        // Retrieve client credentials from AppConfig
        let clientID = AppConfig.spotifyAPIToken
        let clientSecret = AppConfig.spotifySharedSecret

        // Encode client credentials in Base64
        let credentials = Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(credentials)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let parameters: Parameters = [
            "grant_type": "client_credentials"
        ]

        // Perform request with Alamofire
        AF.request(
            authURL,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: SpotifyCredentialsResponse.self) { response in
            switch response.result {
            case .success(let jsonResponse):
                self.spotifyToken = jsonResponse.accessToken
                self.spotifyExpiresAt = String(Int64(Date().timeIntervalSince1970) + Int64(jsonResponse.expiresIn))
                completion(jsonResponse.accessToken)
            case .failure(let error):
                SpotifyAPI.logger.error("Failed to renew Spotify token: \(error.localizedDescription)")
                completion("")
            }
        }
    }

    // MARK: Get Spotify Token

    func getSpotifyToken(completion: @escaping (String) -> Void) {
        let currentTimeSeconds = Int64(Date().timeIntervalSince1970)

        // Check if token is nil or expired
        if spotifyToken == nil || Int64(spotifyExpiresAt ?? "0") == 0 || currentTimeSeconds + 30 > Int64(spotifyExpiresAt ?? "0") ?? 0 {
            renewSpotifyToken { renewedToken in
                completion(renewedToken)
            }
        } else {
            completion(spotifyToken ?? "")
        }
    }
}
