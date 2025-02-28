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
        guard let url = endpoint.url else {
            completion(.failure(ErrorException.apiError(APIError.undefined.message)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add default headers
        var headers = endpoint.headers
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        
        // Add custom headers to the request
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Handle body if provided
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        // Make network request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard response is HTTPURLResponse else {
                completion(.failure(ErrorException.apiError(APIError.internalServerError.message)))
                return
            }
            
            // Handle empty responses (if no data but status code is 2xx)
            guard let data = data else {
                completion(.failure(ErrorException.apiError(APIError.internalServerError.message)))
                return
            }
            
            do {
                // Decode the response data into the expected model type
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["detail"] as? String {
                        completion(.failure(ErrorException.apiError(message)))
                        return
                    } else if json["http detail"] is String {
                        completion(.failure(ErrorException.failedToLoadToken))
                        return
                    } else {
                        do {
                            let decodedResponse = try JSONDecoder().decode(responseType.self, from: data)
                            completion(.success(decodedResponse))
                        } catch {
                            print("Decoding Error: \(error)")
                            completion(.failure(ErrorException.decodingError(error)))
                        }
                    }
                }
            } catch {
                // Handle decoding error
                completion(.failure(ErrorException.decodingError(error)))
            }
        }.resume()
    }
}
