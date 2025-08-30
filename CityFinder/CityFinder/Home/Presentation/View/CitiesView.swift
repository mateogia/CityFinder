//
//  CitiesView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    Text("Cities")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)
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
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    
                    Toggle("Mostrar solo favoritos", isOn: $viewModel.showOnlyFavorites)
                            .padding()
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                    }
                    /*else if viewModel.orderedCities.isEmpty && viewModel.showOnlyFavorites {
                        Text("No hay favoritos")
                            .foregroundStyle(.gray)
                            .padding()
                    }*/ else {
                        VStack {
                            let textCount = viewModel.showOnlyFavorites ? viewModel.orderedCities.count : viewModel.cities.count
                            Text("Showing \(textCount) cities")
                                .font(.footnote)
                                .foregroundStyle(.blue)
                            ScrollView {
                                LazyVStack {
                                    ForEach(viewModel.orderedCities) { city in
                                        CityRowView(city: city, viewModel: viewModel)
                                    }
                                    /*ForEach($viewModel.orderedcities) { $city in
                                         CityRowView(city: $city, viewModel: viewModel)
                                     }*/
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
                }
                .onAppear {
                    if viewModel.firstTime {
                        viewModel.fetchCities()
                    } else {
                        viewModel.filterCitiesBySearchText()
                    }
                }
            }
        }
    }
}
