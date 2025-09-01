//
//  DetailView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 30/08/2025.
//

import SwiftUI

struct DetailView: View {
    @State var city: City
    @StateObject private var viewModel = CityDetailViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                VStack {
                    Text("Detalle")
                    Text(viewModel.cityDetail?.title ?? "1")
                    Text(viewModel.cityDetail?.description ?? "2")
                    Text(viewModel.cityDetail?.extract ?? "3")
                    Text("\(city.name), \(city.country): \(city.long) \(city.lat)")
                    city.isFavorite ? Text("favorite") : Text("Not favorite")
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
            }
        }
        .onAppear {
            viewModel.fetchCityDetail(for: city.name)
        }
    }
}
