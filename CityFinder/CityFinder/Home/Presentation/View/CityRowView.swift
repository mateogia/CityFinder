//
//  CityRowView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 25/08/2025.
//

import SwiftUI

struct CityRowView: View {
    var city: City
    let onToggleFavorite: () -> Void
    let isLandscape: Bool
    let onShowMap: () -> Void
    @State private var animate = false
    
    var body: some View {
        HStack {
            if isLandscape {
                Button(action: onShowMap) {
                    rowInfo
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(HighlightButtonStyle())
            } else {
                NavigationLink {
                    MapView(city: city)
                } label: {
                    rowInfo
                }
                .buttonStyle(HighlightButtonStyle())
            }
            Spacer()
            
            Button {
                onToggleFavorite()
            } label: {
                Image(systemName: city.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.blue)
            }
            .symbolEffect(.bounce, value: city.isFavorite)
            .padding(.trailing, 8)
            .accessibilityIdentifier("favoriteButton_\(city.id)")
            NavigationLink {
                DetailScreen(city: city, onToggleFavorite: onToggleFavorite)
            } label: {
                Text("Detail")
                    .font(.subheadline).bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(HighlightButtonStyle())
            .accessibilityIdentifier("detailButton_\(city.id)")
        }
        .accessibilityIdentifier("cityRow_\(city.id)")
        .padding(.vertical, 6)
    }
    
    var rowInfo: some View {
        VStack(alignment: .leading) {
            Text("\(city.name), \(city.country)")
                .font(.headline)
            Text("Coordinates:\n\(city.lat), \(city.long)")
                .font(.caption)
        }
    }
}
