//
//  CityDetailApi.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

import Foundation

struct CityDetailApi: Decodable {
    let title: String
    let description: String
    let extract: String
    //let thumbnail: ThumbnailApi
}

struct ThumbnailApi: Decodable {
    let source: String
    let width: Int?
    let height: Int?
}
