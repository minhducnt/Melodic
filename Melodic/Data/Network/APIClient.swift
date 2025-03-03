//
//  APIClient.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

class APIClient {
    static let shared = APIClient()

    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, ErrorException>) -> Void
    ) {
        // Validate URL
        guard var urlComponents = URLComponents(string: endpoint.url?.absoluteString ?? "") else {
            completion(.failure(ErrorException.apiError(APIError.undefined.message)))
            return
        }

        // Append query parameters for GET requests
        if endpoint.method == .get, let body = endpoint.body,
           let queryString = String(data: body, encoding: .utf8) {
            let queryItems = queryString
                .split(separator: "&")
                .map { param -> URLQueryItem in
                    let keyValue = param.split(separator: "=").map { String($0) }
                    return URLQueryItem(name: keyValue[0], value: keyValue.count > 1 ? keyValue[1] : nil)
                }
            urlComponents.queryItems = queryItems
        }

        guard let finalURL = urlComponents.url else {
            completion(.failure(ErrorException.apiError(APIError.undefined.message)))
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue

        // Add default headers
        var headers = endpoint.headers
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"

        // Add custom headers to the request
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Only set body for non-GET requests
        if endpoint.method != .get, let body = endpoint.body {
            request.httpBody = body
        }

        // Make network request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ErrorException.apiError(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ErrorException.apiError(APIError.internalServerError.message)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                // Attempt to decode error message from the response
                if let data = data,
                   let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorMessage = errorResponse["message"] as? String {
                    completion(.failure(ErrorException.apiError(errorMessage)))
                } else {
                    completion(.failure(ErrorException.apiError("HTTP Error: \(httpResponse.statusCode)")))
                }
                return
            }

            // Handle empty responses
            guard let data = data else {
                completion(.failure(ErrorException.apiError(APIError.internalServerError.message)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(responseType.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(ErrorException.decodingError(error)))
            }
        }.resume()
    }
}
