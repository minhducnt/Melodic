import Foundation
import os
import SwiftUI

struct SpotifyCredentialsResponse: Codable {
    var accessToken: String
    var expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}
