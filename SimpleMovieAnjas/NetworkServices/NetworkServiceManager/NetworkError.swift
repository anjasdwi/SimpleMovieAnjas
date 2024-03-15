//
//  NetworkError.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import Foundation

enum NetworkError: Error {
    case custom(String)
    case cannotMapToObject
    case nilValue(String)
    case forbidden              // Status code 403
    case notFound               // Status code 404
    case internalServerError    // Status code 500
    case noInternetConnection
    case badRequest

    var errorDescription: String? {
        switch self {
        case .custom(let description):
            return description
        case .noInternetConnection:
            return "Please check your internet connection"
        case .cannotMapToObject:
            return "Cannot map JSON into Decoodable Object"
        case .nilValue(let objectName):
            return "Value of object \(objectName) is null"
        case .forbidden, .internalServerError, .notFound:
            return "You don't have permission access this API"
        case .badRequest:
            return "Bad request"
        }
    }
}
