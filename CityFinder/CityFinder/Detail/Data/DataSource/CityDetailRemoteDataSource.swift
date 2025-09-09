//
//  CityDetailRemoteDataSource.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

import Foundation

struct CityDetailRemoteDataSource: CityDetailRemoteDataSourceProtocol {
    
    func getCityDetail(for cityName: String) async throws -> CityDetailApi {
        let cityNameNormalized = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
        let formatted = cityNameNormalized.prefix(1).uppercased() + cityNameNormalized.dropFirst()

        guard let encoded = formatted.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw URLError(.badURL)
        }
        let urlString = "https://es.wikipedia.org/api/rest_v1/page/summary/\(encoded)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.setValue("CityFinder/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(CityDetailApi.self, from: data)
        return response
    }
}
