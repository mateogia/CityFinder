//
//  CitiesRemoteDataSourceProtocol.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

protocol CitiesRemoteDataSourceProtocol {
    func getCities() async throws -> [CityApi]
}
