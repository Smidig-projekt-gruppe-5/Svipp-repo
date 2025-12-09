import Foundation
import CoreLocation

// Hele API-responsen
struct AutocompleteResponse: Codable {
    let features: [AutocompleteSuggestion]
}

// Ett enkelt forslag
struct AutocompleteSuggestion: Codable, Identifiable {
    let id: String
    let properties: AutocompleteProperties
    let geometry: AutocompleteGeometry
    
    enum CodingKeys: String, CodingKey {
        case properties
        case geometry
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.properties = try container.decode(AutocompleteProperties.self, forKey: .properties)
        self.geometry = try container.decode(AutocompleteGeometry.self, forKey: .geometry)
        
        self.id = UUID().uuidString
    }
    
    init(id: String = UUID().uuidString, properties: AutocompleteProperties, geometry: AutocompleteGeometry) {
        self.id = id
        self.properties = properties
        self.geometry = geometry
    }
}

struct AutocompleteGeometry: Codable {
    let coordinates: [Double]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
    }
}

struct AutocompleteProperties: Codable {
    let formatted: String?
    let address_line1: String?
    let address_line2: String?
    let city: String?
    let country: String?
    let lat: Double?
    let lon: Double?
}
