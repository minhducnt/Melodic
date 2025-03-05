//
//  AppError.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Foundation

// MARK: - AppError Protocol

// Defines a common interface for all errors with a code and message.
protocol AppError {
    var code: String { get set }
    var message: String { get set }
}

// MARK: - NetworkError Struct

// Errors related to network operations.
struct NetworkError: Error, Decodable {
    var apiError: APIError?
    var statusCode: Int?
}

// MARK: - Error Constants

enum ErrorConstants {
    static let connectivityError = "NO_INTERNET_CONNECTION"
    static let serverError = "INTERNAL_SERVER_ERROR"
    static let undefinedError = "UNDEFINED_ERROR"
}

// MARK: - API Error

struct APIError: AppError, Error, Decodable {
    var code: String
    var message: String
}

// MARK: - Predefined error cases

extension APIError {
    static var undefined: APIError {
        APIError(code: ErrorConstants.undefinedError, message: ErrorException.undefined.localeDes)
    }

    static var internalServerError: APIError {
        APIError(code: ErrorConstants.serverError, message: ErrorException.serverError.localeDes)
    }

    static var noInternetError: APIError {
        APIError(code: ErrorConstants.connectivityError, message: ErrorException.noInternetConnection.localeDes)
    }

    static func mapToNetworkError(from apiError: APIError) -> NetworkError {
        return NetworkError(apiError: apiError, statusCode: nil)
    }
}

// MARK: - Error Exception Localized

enum ErrorException: Error, Identifiable {
    var id: String { localeDes }

    // MARK: - Error Cases

    case undefined
    case noInternetConnection
    case apiError(String)
    case networkError(Error)
    case serverError
    case decodingError(Error)
    case otherError(String)
    case genericError
    case unauthorizedAccess
    case failedToLoadToken
    case tokenStoringFailed

    // MARK: - Localized Error Descriptions

    var localeDes: String {
        switch self {
        // Dynamic
        case let .apiError(message):
            return message
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .decodingError(error):
            return "Data decoding error: \(error.localizedDescription)"
        case let .otherError(message):
            return message
        // Constants
        case .genericError:
            return "Something went wrong! Please try again."
        case .unauthorizedAccess:
            return "Access denied."
        case .failedToLoadToken:
            return "Something went wrong! Please try again."
        case .tokenStoringFailed:
            return "Failed to store token."
        case .undefined:
            return "Undefined error occurred."
        case .serverError:
            return "Internal server error occurred."
        case .noInternetConnection:
            return "No internet connectivity."
        }
    }
}
