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
    @Published var loadingState: LoadingState<CityDetail> = .idle
    @Published var errorMessage: String? = nil
    
    private let repository: CityDetailRepositoryProtocol
    
    init(repository: CityDetailRepositoryProtocol = CityDetailRepository()) {
        self.repository = repository
    }
    
    func fetchCityDetail(for cityName: String) async {
        loadingState = .loading
        do {
            self.cityDetail = try await repository.fetchCityDetail(for: cityName)
            if let detail = cityDetail {
                loadingState = .success(detail)
            }
        } catch {
            self.errorMessage = error.localizedDescription
            loadingState = .failure(error)
        }
    }
}
