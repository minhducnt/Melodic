//
//  AppConfig.xcconfig
//  Melodic
//
//  Created by Admin on 28/2/25.
//
import Foundation

enum AppConfig {
    // MARK: - Private

    private static let configDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("File `info.plist` not found")
        }

        return dict
    }()

    // MARK: - Public

    static let baseURL: URL = {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BASEURL") as? String else {
            fatalError("Base url not found")
        }

        guard let url = URL(string: urlString) else {
            fatalError("Invalid url")
        }

        return url
    }()
    
    static let lastFMAPIKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_KEY") as? String else {
            fatalError("LASTFM_API_KEY not found in Info.plist")
        }
        return apiKey
    }()

    static let lastFMSharedSecret: String = {
        guard let sharedSecret = Bundle.main.object(forInfoDictionaryKey: "LASTFM_API_SHARED_SECRET") as? String else {
            fatalError("LASTFM_API_SHARED_SECRET not found in Info.plist")
        }
        return sharedSecret
    }()
}
