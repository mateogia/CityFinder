//
//  CitiesViewModelTests.swift
//  CityFinderTests
//
//  Created by Mateo Giarrocco on 01/09/2025.
//

import XCTest
import Combine
@testable import CityFinder
@MainActor
final class CitiesViewModelTests: XCTestCase {
    
    var viewModel: CitiesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let mockCities: [City] = [
            City(country: "AR", name: "Buenos Aires", id: 1, lat: 34.9, long: -23.3),
            City(country: "AR", name: "Cordoba", id: 2, lat: 22.1, long: -26),
            City(country: "AR", name: "Rosario", id: 3, lat: 29, long: -29.3),
            City(country: "US", name: "Boston", id: 4, lat: 39, long: 60.3)
        ]
        cancellables = []
        viewModel = CitiesViewModel(repository: MockCitiesRepository(dataSource: MockCitiesRemoteDataSource()), searchDebounceInterval: 0)
        viewModel.setCities(cities: mockCities)
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSearchText_FiltersCitiesCorrectly() {
        let expectation = XCTestExpectation(description: "El listado de ciudades se actualiza después del debounce y contiene Boston")
        
        viewModel.$orderedCities
            .sink { cities in
                if cities.count == 1, cities.first?.name == "Boston" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "Bos"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testToggleFavorite_AndFilterByFavorites_ShowsOnlyFavorites() {
        let initialLoaded = expectation(description: "initial orderedCities contains Cordoba")
        viewModel.$orderedCities
            .filter { $0.contains(where: { $0.name == "Cordoba" }) }
            .prefix(1)
            .sink { arr in
                print("[TEST] initialLoaded emitted count=\(arr.count) first=\(arr.first?.name ?? "nil")")
                initialLoaded.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [initialLoaded], timeout: 1.5)
        guard let cordoba = viewModel.orderedCities.first(where: { $0.name == "Cordoba" }) else {
            XCTFail("Cordoba no encontrada aun cuando debería")
            return
        }
        let toggledExpectation = expectation(description: "Filtrar por favoritos muestra sólo Córdoba")
        viewModel.$orderedCities
            .filter { cities in
                cities.contains(where: { $0.name == "Cordoba" && $0.isFavorite })
            }
            .prefix(1)
            .sink { _ in toggledExpectation.fulfill() }
            .store(in: &cancellables)
        viewModel.toggleFavorite(for: cordoba)
        wait(for: [toggledExpectation], timeout: 1.0)
        
        let finalExpectation = expectation(description: "Filtrar por favoritos muestra sólo Córdoba")
        viewModel.$orderedCities
            .drop(while: { !$0.allSatisfy { $0.name == "Cordoba" && $0.isFavorite } }) // nuevo
            .prefix(1)
            .sink { _ in finalExpectation.fulfill() }
            .store(in: &cancellables)
        viewModel.showOnlyFavorites = true
        wait(for: [finalExpectation], timeout: 2.0)
    }
    
    func testSearchText_WhenNoResults_ReturnsEmptyArray() {
        let expectation = XCTestExpectation(description: "Una búsqueda sin coincidencias devuelve un array vacío")
        
        viewModel.$orderedCities
            .sink { cities in
                if cities.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.searchText = "xxxxxxxxx"
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testSearchText_WhenCleared_ReturnsAllCities() {
        let expectation = XCTestExpectation(description: "Al borrar el texto de búsqueda, la lista vuelve al estado original (4 ciudades)")
        viewModel.searchText = "Buenos"
        viewModel.$orderedCities
            .sink { cities in
                if cities.count == 4 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.searchText = ""
        wait(for: [expectation], timeout: 2.5)
    }

}
