
import Foundation
import CoreLocation

// Hele API-responsen
struct AutocompleteResponse: Codable {
    let features: [AutocompleteSuggestion]
}

// Ett enkelt forslag i autocomplete-resultatene
struct AutocompleteSuggestion: Codable, Identifiable {
    var id = UUID()
    let properties: AutocompleteProperties
    let geometry: AutocompleteGeometry
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

// Info fra api
struct AutocompleteProperties: Codable {
    let formatted: String?          // Hele formaterte addressen
    let address_line1: String?      // Adresse
    let address_line2: String?      // By/kommune
    let city: String?
    let country: String?
    let lat: Double?
    let lon: Double?
}
