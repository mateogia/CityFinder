//
//  CitiesViewModelTests.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 01/09/2025.
//

import XCTest
@testable import CityFinder
@MainActor
final class CitiesViewModelTests: XCTestCase {
    
    var viewModel: CitiesViewModel!
    
    override func setUp() async throws {
        let mockCities: [City] = [
            City(country: "AR", name: "Buenos Aires", id: 1, lat: 34.9, long: -23.3),
            City(country: "AR", name: "Cordoba", id: 2, lat: 22.1, long: -26),
            City(country: "AR", name: "Rosario", id: 3, lat: 29, long: -29.3)
        ]
        viewModel = CitiesViewModel(repository: MockCitiesRepository(dataSource: MockCitiesRemoteDataSource()))
        viewModel.setCities(cities: mockCities)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        try await super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSearchExactMatch() async throws {
        viewModel.searchText = "Buenos Aires"
        viewModel.filterCitiesBySearchText()
        
        XCTAssertEqual(viewModel.orderedCities.count, 1)
        XCTAssertEqual(viewModel.orderedCities.first?.name, "Buenos Aires")
    }
    
    func testSearchCaseInsensitive() async throws {
        viewModel.searchText = "cordOBA"
        viewModel.filterCitiesBySearchText()
        
        XCTAssertEqual(viewModel.orderedCities.count, 1)
        XCTAssertEqual(viewModel.orderedCities.first?.name, "Cordoba")
    }
    
    func testSearchInvalidInput() async throws {
        viewModel.searchText = "Tokyo"
        viewModel.filterCitiesBySearchText()
        
        XCTAssertTrue(viewModel.orderedCities.isEmpty)
    }
    
    func testEmptySearchReturnsAllCities() async throws {
        viewModel.searchText = ""
        viewModel.filterCitiesBySearchText()
        
        XCTAssertEqual(viewModel.orderedCities.count, 3)
    }
    
    func testFilterByName() {
        viewModel.searchText = "buenos"
        viewModel.filterCitiesBySearchText()
        XCTAssertEqual(viewModel.orderedCities.count, 1)
        XCTAssertEqual(viewModel.orderedCities.first?.name, "Buenos Aires")
    }
    
    func testFilterIsCaseInsensitive() {
        viewModel.searchText = "ROSARIO"
        viewModel.filterCitiesBySearchText()
        XCTAssertEqual(viewModel.orderedCities.count, 1)
        XCTAssertEqual(viewModel.orderedCities.first?.name, "Rosario")
    }
    
    func testFilterReturnsEmptyIfNoMatch() {
        viewModel.searchText = "Mendoza"
        viewModel.filterCitiesBySearchText()
        XCTAssertTrue(viewModel.orderedCities.isEmpty)
    }
}
