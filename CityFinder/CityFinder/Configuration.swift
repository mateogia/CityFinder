//
//  Configuration.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 08/09/2025.
//

import Foundation

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    private init() {}
    
    // MARK: - API Configuration
    var citiesAPIURL: String {
        return "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
    }
    
    var cityDetailAPIBaseURL: String {
        return "https://en.wikipedia.org/api/rest_v1/page/summary/"
    }
}
