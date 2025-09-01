//
//  CityRowView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 25/08/2025.
//

import SwiftUI

struct CityRowView: View {
    var city: City
    @ObservedObject var viewModel: CitiesViewModel
    let onShowMap: () -> Void
    
    var body: some View {
        HStack {
            NavigationLink {
                MapView(city: city)
            } label: {
                VStack(alignment: .leading) {
                    Text("\(city.name), \(city.country)")
                        .font(.headline)
                    Text("Coordinates: \(city.long), \(city.lat)")
                        .font(.subheadline)
                }
            }
            .buttonStyle(.plain)
            Spacer()
            Button {
                viewModel.toggleFavorite(for: city)
            } label: {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(.plain)
            NavigationLink {
                DetailView(city: city)
            } label: {
                Text("Detail")
                    .font(.subheadline).bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
        .onTapGesture { onShowMap() }
    }
}
