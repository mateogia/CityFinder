//
//  CitiesRepositoryProtocol.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

protocol CitiesRepositoryProtocol {
    var dataSource: CitiesRemoteDataSourceProtocol { get set }
    func fetchCities() async throws -> [City]
}
