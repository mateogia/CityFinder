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
        errorMessage = nil        
        do {
            let detail = try await repository.fetchCityDetail(for: cityName)
            self.cityDetail = detail
            loadingState = .success(detail)
        } catch {
            self.errorMessage = getErrorMessage(for: error)
            loadingState = .failure(error)
        }
    }
    
    private func getErrorMessage(for error: Error) -> String {
        if let appError = error as? AppError {
            return appError.errorDescription ?? "Unknown error occurred"
        }
        return error.localizedDescription
    }
}
