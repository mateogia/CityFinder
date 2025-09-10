//
//  CityDetailRepository.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//
import Foundation

struct CityDetailRepository: CityDetailRepositoryProtocol {
    var dataSource: CityDetailRemoteDataSourceProtocol
        
    init(dataSource: CityDetailRemoteDataSourceProtocol = CityDetailRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func fetchCityDetail(for cityName: String) async throws -> CityDetail {
        let cityDetailDTOs = try await dataSource.getCityDetail(for: cityName)
        let thumbnail = Thumbnail(source: cityDetailDTOs.thumbnail.source,
                                  width: cityDetailDTOs.thumbnail.width,
                                  height: cityDetailDTOs.thumbnail.height)
        
        return CityDetail(title: cityDetailDTOs.title,
                          description: cityDetailDTOs.description,
                          extract: cityDetailDTOs.extract,
                          thumbnail: thumbnail)
    }
}
