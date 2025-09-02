//
//  HomeContainerView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 31/08/2025.
//

import SwiftUI

struct HomeContainerView: View {
    @StateObject private var viewModel = CitiesViewModel()
    @State private var selectedCity: City? = nil
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            Group {
                if isLandscape {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .onChange(of: isLandscape) {
                viewModel.isLandscape.toggle()
            }
            .onAppear {
                if viewModel.firstTime {
                    viewModel.fetchCities()
                } else {
                    viewModel.filterCitiesBySearchText()
                }
                if isLandscape {
                    viewModel.setLandscapeMode()
                }
            }
        }
    }
    var portraitLayout: some View {
        CitiesView(viewModel: viewModel)
            .padding(5)
    }
    var landscapeLayout: some View {
        CitiesView(viewModel: viewModel)
            .padding(5)
    }
}
