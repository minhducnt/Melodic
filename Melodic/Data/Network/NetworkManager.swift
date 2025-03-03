//
//  DefaultNetworkManager.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

// MARK: - Network Manager

protocol NetworkManager {
    func request(
        urlRequest: CustomURLRequest,
        success: @escaping (_ statusCode: Int) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    )

    func request<T: Decodable>(
        urlRequest: CustomURLRequest,
        success: @escaping (_ response: T) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    )
}

// MARK: - Default Network Manager

class DefaultNetworkManager {
    static let shared = DefaultNetworkManager()
    private init() {}

    // MARK: - Sessions

    // Custom Configuration Requests via Alamofire
    private var session: Alamofire.Session = {
        var manager = AF
        manager.session.configuration.httpMaximumConnectionsPerHost = 10
        manager.session.configuration.timeoutIntervalForRequest = 60
        return manager
    }()

    // Realtime check of whether the network is reachable
    var isNetworkReachable: Bool {
        guard let reachabilityManager = NetworkReachabilityManager.default, reachabilityManager.isReachable else {
            return false
        }
        return true
    }

    // MARK: - Requests

    func request(
        urlRequest: CustomURLRequest,
        success: @escaping (_ statusCode: Int) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    ) {
        request(urlRequest: urlRequest) { _, statusCode in
            success(statusCode)
        } failed: { error in
            failed(error)
        }
    }

    func request<T: Decodable>(
        urlRequest: CustomURLRequest,
        success: @escaping (_ response: T) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    ) {
        request(urlRequest: urlRequest) { response, _ in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObj = try decoder.decode(T.self, from: response)
                success(responseObj)
            } catch let DecodingError.keyNotFound(key, context) {
                failed(NetworkError(apiError: APIError(code: "", message: "could not find key \(key) in JSON: \(context.debugDescription)")))
            } catch let DecodingError.valueNotFound(type, context) {
                failed(NetworkError(apiError: APIError(code: "", message: "could not find type \(type) in JSON: \(context.debugDescription)")))
            } catch let DecodingError.typeMismatch(type, context) {
                failed(NetworkError(apiError: APIError(code: "", message: "type mismatch for type \(type) in JSON: \(context.debugDescription)")))
            } catch let DecodingError.dataCorrupted(context) {
                failed(NetworkError(apiError: APIError(code: "", message: "data found to be corrupted in JSON: \(context.debugDescription)")))
            } catch let error as NSError {
                failed(NetworkError(apiError: APIError(code: "", message: "\(error.localizedDescription)")))
            }
        } failed: { error in
            failed(error)
        }
    }
}

// MARK: - Default Network Manager Extension

private extension DefaultNetworkManager {
    // MARK: - Request Default

    func request(
        urlRequest: CustomURLRequest,
        success: @escaping (_ response: Data, _ statusCode: Int) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    ) {
        guard isNetworkReachable else {
            failed(NetworkError(apiError: .noInternetError, statusCode: nil))
            return
        }

        session.request(urlRequest).response { [weak self] response in
            self?.handleAPIResponse(response: response) { response, statusCode in
                success(response, statusCode)
            } failed: { error in
                failed(error)
            }
        }
    }

    // MARK: - Handle Error Response

    func makeError(from data: Data?, code: Int) -> NetworkError {
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let error = try decoder.decode(APIError.self, from: data)
                return NetworkError(apiError: error, statusCode: code)
            } catch {
                return NetworkError(apiError: .undefined, statusCode: code)
            }
        } else {
            return NetworkError(apiError: .undefined, statusCode: code)
        }
    }

    // MARK: - Handle API Response

    func handleAPIResponse(
        response: AFDataResponse<Data?>,
        success: @escaping (_ response: Data, _ statusCode: Int) -> Void,
        failed: @escaping (_ error: NetworkError) -> Void
    ) {
        switch response.result {
        case .success:
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200 ... 299:
                    success(response.data ?? Data(), statusCode)
                case 400 ... 499:
                    failed(makeError(from: response.data, code: statusCode))
                case 500 ... 599:
                    failed(NetworkError(apiError: .internalServerError, statusCode: statusCode))
                default:
                    failed(NetworkError(apiError: .undefined, statusCode: nil))
                }
            } else {
                failed(NetworkError(apiError: .undefined, statusCode: nil))
            }
        case let .failure(error):
            print("API failure with: \(error)")
            ErrorHandler.logError(message: "API failure with: \(error)", error: error)
            failed(NetworkError(apiError: APIError(code: "", message: error.localizedDescription), statusCode: error.responseCode))
        }
    }
}
