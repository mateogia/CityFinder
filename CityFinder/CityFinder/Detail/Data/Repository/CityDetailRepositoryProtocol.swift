//
//  CityDetailRepositoryProtocol.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

protocol CityDetailRepositoryProtocol {
    var dataSource: CityDetailRemoteDataSourceProtocol { get set }
    func fetchCityDetail(for cityName: String) async throws -> CityDetail
}
