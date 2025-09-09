//
//  HeaderView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 07/09/2025.
//

import SwiftUI

struct HeaderView: View {
    let isLandscape: Bool
    @FocusState private var isSearchFocused: Bool
    @ObservedObject var viewModel: CitiesViewModel
    
    var body: some View {
        VStack {
            Text("CityFinder")
                .font(!isLandscape ? .largeTitle : .subheadline)
                .fontWeight(.bold)
                .padding(.vertical, !isLandscape ? 10 : 5)
                .foregroundStyle(.blue)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 2)
                TextField("Find a city here", text: $viewModel.searchText)
                    .focused($isSearchFocused)
                    .disableAutocorrection(true)
                    .padding(.horizontal, 10)
            }
            .frame(height: 44)
            Toggle("Show favorites only", isOn: $viewModel.showOnlyFavorites)
                .padding(.vertical, 5)
                .tint(.blue)
            
            switch viewModel.loadingState {
            case .failure(let errorMessage):
                Text("Error: \(errorMessage)")
            case .success(_):
                if !viewModel.orderedCities.isEmpty {
                    Text(viewModel.citiesCountDescription)
                        .padding(.vertical, 5)
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
            default:
                ProgressView("Loading cities...")
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isSearchFocused = false
                }
        )
    }
}
