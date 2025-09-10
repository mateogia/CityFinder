//
//  NetworkErrorHandler.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 10/09/2025.
//

import Foundation

struct NetworkErrorHandler {
    static func handle(_ error: Error) -> AppError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .networkUnavailable
            case .badURL:
                return .invalidURL
            default:
                return .unknown(error)
            }
        } else if let decodingError = error as? DecodingError {
            return .decodingError
        } else {
            return .unknown(error)
        }
    }
    
    static func handle(_ response: URLResponse?) -> AppError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return .serverError(httpResponse.statusCode)
        case 500...599:
            return .serverError(httpResponse.statusCode)
        default:
            return .unknown(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: nil))
        }
    }
}
