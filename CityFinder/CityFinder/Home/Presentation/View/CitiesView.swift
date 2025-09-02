//
//  CitiesView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject var viewModel: CitiesViewModel
    
    var body: some View {
        NavigationStack() {
            if viewModel.isLandscape {
                HStack {
                    VStack {
                        headerView
                        listView
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Divider()
                    
                    Group {
                        if let selectedCity = viewModel.getSelectedCity() {
                            
                            MapView(city: selectedCity)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("Selecciona una ciudad para ver el mapa")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            } else {
                VStack {
                    headerView
                    listView
                }.padding(10)
            }
        }
    }
    var headerView: some View {
        VStack {
            Text("Cities")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .foregroundStyle(.blue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 2)
                TextField("Search for a city", text: $viewModel.searchText)
                    .onSubmit {
                        viewModel.filterCitiesBySearchText()
                    }
                    .disableAutocorrection(true)
                    .padding(.horizontal, 10)
            }
            .frame(height: 44)
            Toggle("Mostrar solo favoritos", isOn: $viewModel.showOnlyFavorites)
                .padding(.vertical, 5)
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                let textCount = viewModel.showOnlyFavorites ? viewModel.orderedCities.count : viewModel.cities.count
                Text("Showing \(textCount) cities")
                    .font(.footnote)
                    .foregroundStyle(.blue)
            }
        }
    }
    var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.orderedCities) { city in
                    CityRowView(city: city, viewModel: viewModel,
                                isLandscape: viewModel.isLandscape,
                                onShowMap: { viewModel.showCityInMap(city: city)}
                    )
                }
            }
        }
        .onChange(of: viewModel.searchText) {
            viewModel.filterCitiesBySearchText()
            viewModel.updateOrderedCities()
        }
        .onChange(of: viewModel.showOnlyFavorites) {
            viewModel.updateOrderedCities()
        }
        .listStyle(.plain)
        .padding(.horizontal, 15)
        .foregroundStyle(.black, .blue)
    }
}
