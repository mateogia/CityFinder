//
//  MockCitiesRepository.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 01/09/2025.
//

//import CityFinder
@testable import CityFinder

class MockCitiesRepository: CitiesRepositoryProtocol {
    var dataSource: CitiesRemoteDataSourceProtocol
    
    
    init(dataSource: CitiesRemoteDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func fetchCities() async throws -> [City] {
        return [
            City(country: "Argentina", name: "Buenos Aires", id: 1, lat: -34.6, long: -58.38, isFavorite: false),
            City(country: "Spain", name: "Barcelona", id: 2, lat: 41.38, long: 2.17, isFavorite: false),
            City(country: "Germany", name: "Berlin", id: 3, lat: 52.52, long: 13.40, isFavorite: false)
        ]
    }
}
