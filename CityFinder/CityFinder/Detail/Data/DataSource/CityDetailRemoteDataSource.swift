//
//  CityDetailRemoteDataSource.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

import Foundation

struct CityDetailRemoteDataSource: CityDetailRemoteDataSourceProtocol {
    private let session: URLSession
    private let configuration: AppConfiguration
    
    init(session: URLSession = .shared, configuration: AppConfiguration = .shared) {
        self.session = session
        self.configuration = configuration
    }
    
    func getCityDetail(for cityName: String) async throws -> CityDetailApi {
        let cityNameNormalized = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
        let formatted = cityNameNormalized.prefix(1).uppercased() + cityNameNormalized.dropFirst()

        guard let encoded = formatted.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw AppError.invalidURL
        }
        
        let urlString = "\(configuration.cityDetailAPIUrl)\(encoded)"
        guard let url = URL(string: urlString) else {
            throw AppError.invalidURL
        }
        var request = URLRequest(url: url)
        request.setValue("CityFinder/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            if let error = NetworkErrorHandler.handle(response) {
                throw error
            }
            guard !data.isEmpty else {
                throw AppError.invalidResponse
            }
            let decodedResponse = try JSONDecoder().decode(CityDetailApi.self, from: data)
            return decodedResponse
        } catch let error as AppError {
            throw error
        } catch {
            throw NetworkErrorHandler.handle(error)
        }
    }
}
