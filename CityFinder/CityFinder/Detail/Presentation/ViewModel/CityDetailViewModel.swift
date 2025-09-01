//
//  CityDetailViewModel.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//
import SwiftUI
@MainActor
class CityDetailViewModel: ObservableObject {
    @Published var cityDetail: CityDetail?
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    private let repository: CityDetailRepositoryProtocol
    
    init(repository: CityDetailRepositoryProtocol = CityDetailRepository()) {
        self.repository = repository
    }
    
    func fetchCityDetail(for cityName: String) {
        isLoading = true
        Task {
            do {
                self.cityDetail = try await repository.fetchCityDetail(for: cityName)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
