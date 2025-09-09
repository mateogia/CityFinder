//
//  CitiesRemoteDataSource.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//
import Foundation

struct CitiesRemoteDataSource: CitiesRemoteDataSourceProtocol {
    func getCities() async throws -> [CityApi] {
        guard let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([CityApi].self, from: data)
        return response
    }
}
