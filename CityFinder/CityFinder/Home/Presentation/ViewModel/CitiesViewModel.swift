//
//  CitiesViewModel.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var allCities: [City] = []
    @Published var firstTime: Bool = true
    @Published var showOnlyFavorites: Bool = false
    @Published var orderedCities: [City] = []
    
    private let repository: CitiesRepositoryProtocol
    
    init(repository: CitiesRepositoryProtocol = CitiesRepository()) {
        self.repository = repository
    }
    
    func fetchCities() {
        isLoading = true
        Task {
            do {
                let cities = try await repository.fetchCities()
                self.cities = cities
                self.allCities = cities
                updateOrderedCities()
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
        firstTime = false
    }
    
    func updateOrderedCities() {
        var result = cities
        if showOnlyFavorites {
            result = result.filter { $0.isFavorite }
        } else {
            result = cities
        }
        orderedCities = result.sorted {
            ($0.name, $0.country) < ($1.name, $1.country)
        }
    }
    
    func filterCitiesBySearchText() {
        cities = allCities
        if !searchText.isEmpty {
            cities = cities.filter { city in
                city.name.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            cities = allCities
        }
    }
    
    func toggleFavorite(for city: City) {
        if let citiesIndex = cities.firstIndex(where: { $0.id == city.id }),
           let allcitiesIndex = allCities.firstIndex(where: { $0.id == city.id }) {
            cities[citiesIndex].isFavorite.toggle()
            allCities[allcitiesIndex].isFavorite.toggle()
            updateOrderedCities()
        }
    }
}
