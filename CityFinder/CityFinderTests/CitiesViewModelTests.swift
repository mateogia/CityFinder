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
    var mockDataSource: MockCitiesRemoteDataSource!

    override func setUp() {
        super.setUp()
        mockDataSource = MockCitiesRemoteDataSource()
        let mockRepository = MockCitiesRepository(dataSource: mockDataSource)
        viewModel = CitiesViewModel(repository: mockRepository, searchDebounceInterval: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataSource = nil
        super.tearDown()
    }
    
    private func createTestCities() -> [City] {
        return [
            City(country: "US", name: "Boston", id: 1, lat: 42.36, long: -71.06, isFavorite: false),
            City(country: "AR", name: "Cordoba", id: 2, lat: -31.42, long: -64.19, isFavorite: false),
            City(country: "US", name: "Bogota", id: 3, lat: 43.62, long: -116.21, isFavorite: false),
            City(country: "ES", name: "Barcelona", id: 4, lat: 41.39, long: 2.16, isFavorite: false)
        ]
    }
    
    func test_filterAndSortCities_whenNoFilters_returnsAllCitiesSorted() {
        // Given
        let cities = createTestCities()
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "", showOnlyFavorites: false)
        // Then
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0].name, "Barcelona")
        XCTAssertEqual(result[1].name, "Bogota")
        XCTAssertEqual(result[2].name, "Boston")
        XCTAssertEqual(result[3].name, "Cordoba")
    }
    
    func test_filterAndSortCities_whenSearchTextProvided_filtersByName() {
        // Given
        let cities = createTestCities()
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "Bo", showOnlyFavorites: false)
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "Bogota")
        XCTAssertEqual(result[1].name, "Boston")
    }
    
    func test_filterAndSortCities_whenSearchTextProvided_isCaseInsensitive() {
        // Given
        let cities = createTestCities()
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "bO", showOnlyFavorites: false)
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "Bogota")
        XCTAssertEqual(result[1].name, "Boston")
    }
    
    func test_filterAndSortCities_whenShowOnlyFavoritesTrue_filtersFavorites() {
        // Given
        var cities = createTestCities()
        cities[0].isFavorite = true
        cities[2].isFavorite = true
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "", showOnlyFavorites: true)
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "Bogota")
        XCTAssertEqual(result[1].name, "Boston")
    }
    
    func test_filterAndSortCities_whenBothFiltersActive_filtersCorrectly() {
        // Given
        var cities = createTestCities()
        cities[0].isFavorite = true
        cities[1].isFavorite = true
        cities[2].isFavorite = true
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "Bo", showOnlyFavorites: true)
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, "Bogota")
        XCTAssertEqual(result[1].name, "Boston")
    }
    
    func test_filterAndSortCities_whenSearchTextEmpty_returnsEmptyArray() {
        // Given
        let cities = createTestCities()
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "   ", showOnlyFavorites: false)
        // Then
        XCTAssertEqual(result.count, 0)
    }
    
    func test_filterAndSortCities_whenNoFavoritesAndFilterActive_returnsEmptyArray() {
        // Given
        let cities = createTestCities()
        // When
        let result = viewModel.filterAndSortCities(cities: cities, searchText: "", showOnlyFavorites: true)
        // Then
        XCTAssertEqual(result.count, 0)
    }
    
    func test_setCities_whenCalled_updatesOrderedCities() {
        // Given
        let cities = createTestCities()
        // When
        viewModel.setCities(cities: cities)
        // Then
        XCTAssertEqual(viewModel.orderedCities.count, 4)
        XCTAssertEqual(viewModel.orderedCities[0].name, "Barcelona")
    }
    
    func test_citiesCountDescription_whenShowOnlyFavoritesFalse_showsTotalCount() {
        // Given
        let cities = createTestCities()
        viewModel.setCities(cities: cities)
        viewModel.showOnlyFavorites = false
        // When
        let description = viewModel.citiesCountDescription
        // Then
        XCTAssertEqual(description, "Showing 4 cities")
    }
    
    func test_citiesCountDescription_whenShowOnlyFavoritesTrue_showsFavoritesCount() {
        // Given
        var cities = createTestCities()
        cities[0].isFavorite = true
        cities[1].isFavorite = true
        viewModel.setCities(cities: cities)
        viewModel.showOnlyFavorites = true
        viewModel.refreshOrderedCities()
        // When
        let description = viewModel.citiesCountDescription
        // Then
        XCTAssertEqual(description, "Showing 2 favorite cities")
    }
    
    func test_searchAndFavoritesIntegration_whenBothActive_filtersCorrectly() {
        // Given
        var cities = createTestCities()
        cities[0].isFavorite = true
        cities[2].isFavorite = true
        viewModel.setCities(cities: cities)
        viewModel.showOnlyFavorites = true
        viewModel.searchText = "Bo"
        viewModel.refreshOrderedCities()
        // When
        let description = viewModel.citiesCountDescription
        // Then
        XCTAssertEqual(description, "Showing 2 favorite cities")
        XCTAssertEqual(viewModel.orderedCities.count, 2)
        XCTAssertEqual(viewModel.orderedCities[0].name, "Bogota")
        XCTAssertEqual(viewModel.orderedCities[1].name, "Boston")
    }
}
