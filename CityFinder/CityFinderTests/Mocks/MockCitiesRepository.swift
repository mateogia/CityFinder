//
//  MockCitiesRepository.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 01/09/2025.
//

@testable import CityFinder

class MockCitiesRepository: CitiesRepositoryProtocol {
    var dataSource: CitiesRemoteDataSourceProtocol
    
    
    init(dataSource: CitiesRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchCities() async throws -> [City] {
        let citiesApi = try await dataSource.getCities()
        return citiesApi.map { City(country: $0.country, name: $0.name, id: $0.id, lat: $0.coord.lat, long: $0.coord.lon) }
    }
}
