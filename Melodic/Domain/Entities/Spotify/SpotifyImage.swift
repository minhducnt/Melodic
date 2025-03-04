import Alamofire
import Cache
import Foundation
import os

struct SpotifyImage: Codable {
    // MARK: - Properties

    var url: String
    var height: Int
    var width: Int

    static let DefaultImage = LastFMImage.fixture().url

    // MARK: - Logger

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LastFMAPI.self)
    )

    // MARK: - Functions

    static func findImage(type: String, name: String, completion: @escaping (String?) -> Void) {
        // MARK: - Memoization Handling

        let diskConfig = DiskConfig(name: "firstfm.spotify.images")
        let memoryConfig = MemoryConfig()
        let fileManager = FileManager()

        let storage = try? Storage<String, SpotifyImage>(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            fileManager: fileManager,
            transformer: TransformerFactory.forCodable(ofType: SpotifyImage.self)
        )

        let cacheKey = "\(type).\(name)"

        // Check cache before making API call
        if let cachedImage = try? storage?.object(forKey: cacheKey) {
            completion(cachedImage.url)
            return
        }

        // MARK: - Fetch Spotify Image

        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(DefaultImage)
            return
        }

        let queryURLString = "https://api.spotify.com/v1/search?q=\(encodedName)&type=\(type)&limit=1"

        SpotifyAPI.shared.getSpotifyToken { spotifyToken in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(spotifyToken)",
                "Content-Type": "application/json"
            ]

            switch type {
            case "track":
                AF.request(queryURLString, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: SpotifyTrackSearchResponse.self) { response in
                        processSpotifyResponse(response: response, cacheKey: cacheKey, storage: storage, completion: completion)
                    }

            case "album":
                AF.request(queryURLString, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: SpotifyAlbumSearchResponse.self) { response in
                        processSpotifyResponse(response: response, cacheKey: cacheKey, storage: storage, completion: completion)
                    }

            case "artist":
                AF.request(queryURLString, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: SpotifyArtistSearchResponse.self) { response in
                        processSpotifyResponse(response: response, cacheKey: cacheKey, storage: storage, completion: completion)
                    }

            default:
                completion(DefaultImage)
            }
        }
    }

    // MARK: - Generic Response Handler

    private static func processSpotifyResponse<T: Codable>(
        response: DataResponse<T, AFError>,
        cacheKey: String,
        storage: Storage<String, SpotifyImage>?,
        completion: @escaping (String?) -> Void
    ) {
        switch response.result {
        case .success(let jsonResponse):
            if let imageUrl = extractImageURL(from: jsonResponse) {
                try? storage?.setObject(imageUrl, forKey: cacheKey)
                completion(imageUrl.url)
            } else {
                completion(DefaultImage)
            }
        case .failure(let error):
            logger.error("Spotify image search error: \(error.localizedDescription)")
            completion(DefaultImage)
        }
    }

    // MARK: - Extract Image URL

    private static func extractImageURL(from response: Codable) -> SpotifyImage? {
        if let trackResponse = response as? SpotifyTrackSearchResponse {
            return trackResponse.tracks.items.first?.album.images.first
        }
        if let albumResponse = response as? SpotifyAlbumSearchResponse {
            return albumResponse.albums.items.first?.images.first
        }
        if let artistResponse = response as? SpotifyArtistSearchResponse {
            return artistResponse.artists.items.first?.images.first
        }
        return nil
    }
}
