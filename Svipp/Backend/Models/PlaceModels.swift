import Foundation
import CoreLocation

struct PlaceResponse: Codable {
    let features: [PlaceFeature]
}

// Et enkelt sted fra API
struct PlaceFeature: Codable, Identifiable {
    // Lokal id – lages i appen, IKKE fra API
    let id = UUID()
    
    let properties: PlaceProperties
    let geometry: PlaceGeometry
    
    // Viktig: vi FJERNER "id" fra det som forventes fra JSON
    private enum CodingKeys: String, CodingKey {
        case properties
        case geometry
    }
}

// Koordinater fra API
struct PlaceGeometry: Codable {
    let coordinates: [Double]

    var coordinate: CLLocationCoordinate2D {
        guard coordinates.count >= 2 else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        // Geoapify: [lon, lat]
        return CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
    }
}

// Data fra plasser
struct PlaceProperties: Codable {
    let name: String?
    let address_line2: String?
    let country: String?
    let city: String?
    
    // Gjør disse gjerne optional – noen steder mangler lat/lon i properties
    let lon: Double?
    let lat: Double?
    
    let categories: [String]?
    
    // Avstand fra bruker - brukes bare i appen
    var distanceFromUser: Double?
}
