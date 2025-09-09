//
//  HomeScreen.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = CitiesViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isLandscape = geo.size.width > geo.size.height
                    CitiesView(viewModel: viewModel, isLandscape: isLandscape)
                    .padding(5)
                    .toolbar(isLandscape ? .hidden : .automatic, for: .navigationBar)
            }
            .task {
                if case .idle = viewModel.loadingState {
                    await viewModel.fetchCities()
                }
            }
        }
        .prewarmKeyboard() // para que permita tipear rápidamente al aparecer la vista por primera vez
    }
}
