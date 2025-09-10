//
//  CityApi.swift
//  NewsNow
//
//  Created by Mateo Giarrocco on 20/06/2024.
//

import Foundation

struct CityApi: Decodable {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinatesApi
    
    private enum CodingKeys: String, CodingKey {
        case country
        case name
        case id = "_id"
        case coord
    }
}

struct CoordinatesApi: Decodable {
    let lat: Double
    let lon: Double
}
