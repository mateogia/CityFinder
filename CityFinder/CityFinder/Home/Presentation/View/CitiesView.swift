//
//  CitiesView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 24/08/2025.
//

import SwiftUI

struct CitiesView: View {
    @ObservedObject var viewModel: CitiesViewModel
    let isLandscape: Bool
    @State var cityForMap: City? = nil
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        if isLandscape {
            HStack {
                VStack {
                    HeaderView(isLandscape: isLandscape, viewModel: viewModel)
                    Spacer()
                    if case .success = viewModel.loadingState {
                        if !viewModel.orderedCities.isEmpty {
                            listView
                        } else {
                            ContentUnavailableView(
                                "No cities found",
                                systemImage: "magnifyingglass",
                                description: Text("\nSearch for a different city or turn off the 'favorites' toggle"))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue.opacity(0.3))
                            )
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                            
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                Group {
                    if let selectedCity = cityForMap {
                        MapView(city: selectedCity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ContentUnavailableView(
                            "Select a city to see\n its location on the map",
                            systemImage: "map")
                        .background(Color.blue.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.all, 20)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack {
                HeaderView(isLandscape: isLandscape, viewModel: viewModel)
                Spacer()
                if case .success = viewModel.loadingState {
                    if !viewModel.orderedCities.isEmpty {
                        listView
                    } else {
                        ContentUnavailableView(
                            "No cities found",
                            systemImage: "magnifyingglass",
                            description: Text("\nSearch for a different city or turn off the 'favorites' toggle"))
                        .background(Color.blue.opacity(0.3), in: RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .padding(10)
        }
    }

    var listView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.orderedCities) { city in
                    CityRowView(city: city,
                                onToggleFavorite: { viewModel.toggleFavorite(for: city) },
                                isLandscape: isLandscape,
                                onShowMap: { cityForMap = city }
                    )
                    Divider()
                    .padding(.horizontal, 8)
                }
            }
            .padding(.vertical, 8)
        }
    }
}
