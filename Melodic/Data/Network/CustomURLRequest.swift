//
//  CustomURLRequest.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import Alamofire
import Foundation

// MARK: - URLCreationError enum represents errors associated with URL creation

enum URLCreationError: Error {
    case failedcreatingURL
}

// MARK: - Create custom URL request

protocol CustomURLRequest: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: Alamofire.ParameterEncoding? { get }
    var parameters: [String: Any]? { get }
}
