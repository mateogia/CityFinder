//
//  CitiesRepository.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

struct CitiesRepository: CitiesRepositoryProtocol {
    var dataSource: CitiesRemoteDataSourceProtocol
        
    init(dataSource: CitiesRemoteDataSourceProtocol = CitiesRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func fetchCities() async throws -> [City] {
        let citiesDTOs = try await dataSource.getCities()
        return citiesDTOs.map { City(country: $0.country, name: $0.name, id: $0.id, lat: $0.coord.lat, long: $0.coord.lon) }
    }
}
