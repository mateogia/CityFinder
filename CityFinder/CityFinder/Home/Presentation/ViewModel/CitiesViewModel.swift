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
    private var favoriteIDs: Set<Int> = []
    @Published var isLandscape: Bool = false
    @Published var cityForMap: City? = nil
    
    private let repository: CitiesRepositoryProtocol
    
    init(repository: CitiesRepositoryProtocol = CitiesRepository()) {
        self.repository = repository
        loadFavorites()
    }
    
    func fetchCities() {
        isLoading = true
        Task {
            do {
                let cities = try await repository.fetchCities()
                self.cities = cities
                self.allCities = cities
                applyFavoritesToLoadedCities()
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
        updateOrderedCities()
    }
    
    func toggleFavorite(for city: City) {
        if let citiesIndex = cities.firstIndex(where: { $0.id == city.id }),
           let allcitiesIndex = allCities.firstIndex(where: { $0.id == city.id }) {
            cities[citiesIndex].isFavorite.toggle()
            allCities[allcitiesIndex].isFavorite.toggle()
            let nowFavorite = (cities.first(where: { $0.id == city.id })?.isFavorite ?? false)
            if nowFavorite {
                favoriteIDs.insert(city.id)
            } else {
                favoriteIDs.remove(city.id)
            }
            updateOrderedCities()
            saveFavorites()
        }
    }
    
    private func saveFavorites() {
        let arr = Array(favoriteIDs)
        UserDefaults.standard.set(arr, forKey: DefaultsKeys.favoriteCityIDs)
    }
    
    private func loadFavorites() {
        let stored = UserDefaults.standard.array(forKey: DefaultsKeys.favoriteCityIDs) ?? []
        let ints: [Int] = stored.compactMap { item in
            if let num = item as? NSNumber { return num.intValue }
            return nil
        }
        favoriteIDs = Set(ints)
        applyFavoritesToLoadedCities()
    }
    
    private func applyFavoritesToLoadedCities() { // borrar alguno?
        if !allCities.isEmpty {
            let newAll = allCities.map { city -> City in
                var c = city
                c.isFavorite = favoriteIDs.contains(c.id)
                return c
            }
            allCities = newAll
        }
        
        if !cities.isEmpty {
            let newCities = cities.map { city -> City in
                var c = city
                c.isFavorite = favoriteIDs.contains(c.id)
                return c
            }
            cities = newCities
        }
        
        if !orderedCities.isEmpty {
            let newOrdered = orderedCities.map { city -> City in
                var c = city
                c.isFavorite = favoriteIDs.contains(c.id)
                return c
            }
            orderedCities = newOrdered
        }
    }
    
    func setLandscapeMode() {
        self.isLandscape = true
    }
    func showCityInMap(city: City) {
        self.cityForMap = city
    }
    func getSelectedCity() -> City? {
        return cityForMap
    }
    
    // for testing
    func setCities(cities: [City]) {
        self.allCities = cities
        updateOrderedCities()
    }
}

enum DefaultsKeys {
    static let favoriteCityIDs = "favoriteCityIDs"
}
