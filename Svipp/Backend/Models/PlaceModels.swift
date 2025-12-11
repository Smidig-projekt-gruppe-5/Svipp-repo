import Foundation
import CoreLocation

struct PlaceResponse: Codable {
    let features: [PlaceFeature]
}

// et enkelt sted fra API
struct PlaceFeature: Codable, Identifiable {
    let id = UUID()
    let properties: PlaceProperties
    let geometry: PlaceGeometry
    
    private enum CodingKeys: String, CodingKey {
        case properties
        case geometry
    }
}

// koordinater fra API
struct PlaceGeometry: Codable {
    let coordinates: [Double]

    var coordinate: CLLocationCoordinate2D {
        guard coordinates.count >= 2 else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
    }
}

// data fra plasser
struct PlaceProperties: Codable {
    let name: String?
    let address_line2: String?
    let country: String?
    let city: String?
    let lon: Double?
    let lat: Double?
    let categories: [String]?
    
    var distanceFromUser: Double?
}
