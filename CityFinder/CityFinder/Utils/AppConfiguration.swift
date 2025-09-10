//
//  AppConfiguration.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 10/09/2025.
//
import Foundation

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    private init() {}
    
    var citiesAPIUrl: String {
        return "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
    }
    
    var cityDetailAPIUrl: String {
        return "https://es.wikipedia.org/api/rest_v1/page/summary/"
    }
}
