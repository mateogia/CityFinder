//
//  MapView.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 30/08/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var city: City
    //@State private var region: MKCoordinateRegion

    init(city: City) {
        self.city = city
        let center = CLLocationCoordinate2D(latitude: city.lat, longitude: city.long)
        /*_region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))*/
    }
    
    var body: some View {
        Text("Mapa")
        Text("\(city.name), \(city.country): \(city.long) \(city.lat)")
        let center = CLLocationCoordinate2D(latitude: city.lat, longitude: city.long)
        Map(initialPosition: .region(MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))) {
            Annotation(city.name, coordinate: center) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
            }
        }
        .navigationTitle("Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}
