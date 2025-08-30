//
//  CityRowView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 25/08/2025.
//

import SwiftUI

struct CityRowView: View {
    var city: City
    //@Binding var city: City
    @ObservedObject var viewModel: CitiesViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(city.name), \(city.country)")
                    .font(.headline)
                Text("Coordinates: \(city.long), \(city.lat)")
                    .font(.subheadline)
            }
            Spacer()
            Button {
                viewModel.toggleFavorite(for: city)
            } label: {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(.plain)
        }
    }
}
