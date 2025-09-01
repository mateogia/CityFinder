//
//  City.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

struct City: Identifiable {
    let country: String
    let name: String
    let id: Int
    let lat: Double
    let long: Double
    var isFavorite: Bool = false
}
