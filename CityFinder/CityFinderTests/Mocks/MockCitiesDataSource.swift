//
//  MockCitiesDataSource.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 01/09/2025.
//
@testable import CityFinder
import Foundation

class MockCitiesRemoteDataSource: CitiesRemoteDataSourceProtocol {
    
    var shouldThrowError = false
    var mockCities: [CityApi] = []

    func getCities() async throws -> [CityApi] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockCities
    }
}
