//
//  AppError.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 10/09/2025.
//

import Foundation

enum AppError: LocalizedError {
    case networkUnavailable
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "No internet connection available"
        case .invalidURL:
            return "Invalid URL format"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError:
            return "Failed to parse data"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
