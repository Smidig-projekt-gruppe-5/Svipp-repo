//
//  PlaceModels.swift
//  Svipp
//
//  Created by Hannan Moussa on 03/12/2025.
//

import Foundation
import CoreLocation

struct PlaceResponse: Codable
{
    let features: [PlaceFeature]
}

//Et enkeltsted fra API
struct PlaceFeature: Codable, Identifiable
{
    var id = UUID()
    let properties: PlaceProperties
    let geometry: PlaceGeometry
}

//Koordinater fra API
struct PlaceGeometry: Codable
{
    let coordinates: [Double]

    var coordinate: CLLocationCoordinate2D
    {
        CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
    }
}

//Data fra plasser
struct PlaceProperties: Codable
{
    let name: String?
    let address_line2: String?
    let country: String?
    let city: String?
    let lon: Double
    let lat: Double
    let categories: [String]?
    
    //Avstand fra bruker - evt videreutvikling
    var distanceFromUser: Double?
}
