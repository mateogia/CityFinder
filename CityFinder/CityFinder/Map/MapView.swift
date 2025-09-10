//
//  MapView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 30/08/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    let city: City
    @State private var position: MapCameraPosition

    init(city: City) {
        self.city = city
        self._position = State(initialValue: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.long),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        ))
    }
    
    var body: some View {
        Map(position: $position) {
            Marker(city.name, coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.long))
        }
        .onChange(of: city.id) {
            position = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.long),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
    }
}
