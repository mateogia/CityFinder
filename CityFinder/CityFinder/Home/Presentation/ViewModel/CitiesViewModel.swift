//
//  CitiesViewModel.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CitiesViewModel: ObservableObject {
    @Published private var cities: [City] = []
    @Published var orderedCities: [City] = []
    @Published var loadingState: LoadingState<[City]> = .idle
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var showOnlyFavorites: Bool = false
    private var favoriteIDs: Set<Int> = []
    private let repository: CitiesRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let searchDebounceInterval: TimeInterval
    var citiesCountDescription: String {
        return showOnlyFavorites ? "Showing \(orderedCities.count) favorite cities" : "Showing \(orderedCities.count) cities"
    }
    
    init(repository: CitiesRepositoryProtocol = CitiesRepository(), searchDebounceInterval: TimeInterval = 0.30) {
        self.repository = repository
        self.searchDebounceInterval = searchDebounceInterval
        loadFavorites()
        setupBindings()
    }
    
    func fetchCities() async {
        loadingState = .loading
        do {
            let cities = try await repository.fetchCities()
            self.cities = cities
            applyFavoritesToLoadedCities()
            filterAndSortCities(cities: cities, searchText: searchText, showOnlyFavorites: showOnlyFavorites)
            loadingState = .success(cities)
        } catch {
            self.errorMessage = error.localizedDescription
            loadingState = .failure(error)
        }
    }
    
    func filterAndSortCities(cities: [City], searchText: String, showOnlyFavorites: Bool) -> [City] {
        var result = cities
        if showOnlyFavorites {
            result = result.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result.sorted {
            ($0.name, $0.country) < ($1.name, $1.country)
        }
    }
    
    private func setupBindings() {
        let searchPublisher = $searchText
            .debounce(for: .milliseconds(Int(searchDebounceInterval * 1000)), scheduler: RunLoop.main)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .eraseToAnyPublisher()
        Publishers.CombineLatest3($cities, searchPublisher, $showOnlyFavorites)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .map { [weak self] citiesP, searchTextP, showOnlyFavsP -> [City] in
                guard let self = self else { return [] }
                let result = self.filterAndSortCities(cities: citiesP, searchText: searchTextP, showOnlyFavorites: showOnlyFavsP)
                return result
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.orderedCities = result
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite(for city: City) {
        if let index = cities.firstIndex(where: { $0.id == city.id }) {
            var newCities = cities
            newCities[index].isFavorite.toggle()
            cities = newCities
            if newCities[index].isFavorite {
                favoriteIDs.insert(cities[index].id)
            } else {
                favoriteIDs.remove(cities[index].id)
            }
            self.saveFavorites()
            orderedCities = filterAndSortCities(cities: self.cities,
                                                         searchText: self.searchText,
                                                         showOnlyFavorites: self.showOnlyFavorites)
        }
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: DefaultsKeys.favoriteCityIDs)
    }
    
    private func loadFavorites() {
        let stored = UserDefaults.standard.array(forKey: DefaultsKeys.favoriteCityIDs) ?? []
        let ints: [Int] = stored.compactMap { item in
            if let num = item as? NSNumber { return num.intValue }
            return nil
        }
        favoriteIDs = Set(ints)
    }
    
    private func applyFavoritesToLoadedCities() {
        cities = cities.map { city in
            var mutableCity = city
            mutableCity.isFavorite = favoriteIDs.contains(mutableCity.id)
            return mutableCity
        }
    }
    
    // for testing:
    func setCities(cities: [City]) {
        self.cities = cities
        applyFavoritesToLoadedCities()
        self.orderedCities = filterAndSortCities(cities: self.cities,
                                                 searchText: self.searchText,
                                                 showOnlyFavorites: self.showOnlyFavorites)
    }
}

enum DefaultsKeys {
    static let favoriteCityIDs = "favoriteCityIDs"
}
