//
//  CitiesRemoteDataSource.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//
import Foundation

struct CitiesRemoteDataSource: CitiesRemoteDataSourceProtocol {
    private let session: URLSession
    private let configuration: AppConfiguration
    
    init(session: URLSession = .shared, configuration: AppConfiguration = .shared) {
        self.session = session
        self.configuration = configuration
    }
    
    func getCities() async throws -> [CityApi] {
        guard let url = URL(string: configuration.citiesAPIUrl) else {
            throw AppError.invalidURL
        }
        do {
            let (data, response) = try await session.data(from: url)
            if let error = NetworkErrorHandler.handle(response) {
                throw error
            }
            guard !data.isEmpty else {
                throw AppError.invalidResponse
            }
            let decodedResponse = try JSONDecoder().decode([CityApi].self, from: data)
            return decodedResponse
        } catch let error as AppError {
            throw error
        } catch {
            throw NetworkErrorHandler.handle(error)
        }
    }
}
