//
//  APIClient.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

class APIClient {
    // MARK: - Properties

    static let shared = APIClient()

    // MARK: - Functions

    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, ErrorException>) -> Void
    ) {
        // MARK: - Setup Client
        
        // Validate and construct URL
        guard var urlComponents = URLComponents(string: endpoint.url?.absoluteString ?? "") else {
            completion(.failure(ErrorException.apiError(APIError.undefined.message)))
            return
        }

        // Append query parameters for GET requests
        if endpoint.method == .get, let body = endpoint.body {
            if let queryString = String(data: body, encoding: .utf8) {
                urlComponents.queryItems = queryString.split(separator: "&").compactMap { param in
                    let keyValue = param.split(separator: "=").map(String.init)
                    return keyValue.count > 1 ? URLQueryItem(name: keyValue[0], value: keyValue[1]) : nil
                }
            }
        }

        // Get the final url
        guard let finalURL = urlComponents.url else {
            completion(.failure(ErrorException.apiError(APIError.undefined.message)))
            return
        }

        // Set default headers
        var headers = endpoint.headers
        headers.add(name: "Accept", value: "application/json")
        headers.add(name: "Content-Type", value: "application/json")

        // Configure request parameters for GET requests
        let parameters: Parameters? = {
            if endpoint.method == .get, let body = endpoint.body {
                return try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
            }
            return nil
        }()

        // MARK: - Network request

        AF.request(
            finalURL,
            method: endpoint.method,
            parameters: parameters,
            encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        )
        .validate()
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                let statusCode = response.response?.statusCode ?? 0
                let errorMessage: String = {
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        return message
                    }
                    return "HTTP Error: \(statusCode)"
                }()
                completion(.failure(ErrorException.apiError(errorMessage)))
            }
        }
    }
}
