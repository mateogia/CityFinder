//
//  CityDetailRemoteDataSourceProtocol.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

protocol CityDetailRemoteDataSourceProtocol {
    func getCityDetail(for cityName: String) async throws -> CityDetailApi
}
