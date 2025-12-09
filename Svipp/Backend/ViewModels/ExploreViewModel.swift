import Foundation
import SwiftUI
import CoreLocation


@MainActor
class ExploreViewModel: ObservableObject {
    
    @Published var lastSearchCoordinate: CLLocationCoordinate2D?
    
    @Published var query: String = ""
    @Published var suggestions: [AutocompleteSuggestion] = []
    
    // Fra API
    @Published var places: [PlaceFeature] = []
    
    // Sjåfører som skal vises i Explore
    @Published var drivers: [DriverInfo] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let autocompleteService = AutocompleteService()
    private let apiService = ApiService()
    
    // Lagrede sjåfører
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
        loadDrivers()
    }
    
    // 🔥 Gjør brukerens søketekst om til gyldig Geoapify-kategori
    func normalizedCategory(from text: String) -> String {
        let lower = text.lowercased()

        if lower.contains("pizza") { return "catering.restaurant" }
        if lower.contains("kebab") { return "catering.restaurant" }
        if lower.contains("burger") { return "catering.fast_food" }
        if lower.contains("mat") { return "catering.restaurant" }
        if lower.contains("kafe") { return "catering.cafe" }
        if lower.contains("butikk") { return "commercial.supermarket" }
        if lower.contains("bar") { return "catering.bar" }

        // fallback-kategori → gir ALLTID resultater
        return "catering.restaurant"
    }
    
    func loadDrivers() {
        // Bruk hardkodede sjåfører
        var list = DriverInfoData.all
        
        // Gi tilfeldige koordinater rundt Oslo
        for i in list.indices {
            list[i].latitude = 59.91 + Double.random(in: -0.01...0.01)
            list[i].longitude = 10.75 + Double.random(in: -0.01...0.01)
        }
        
        self.drivers = list
    }
    
    func searchAutocomplete() async {
        guard !query.isEmpty else {
            suggestions = []
            return
        }
        
        print(" Kaller autocomplete API for: \(query)")
        
        do {
            let result = try await autocompleteService.autocomplete(query: query)
            self.suggestions = result
            print("Fikk \(result.count) forslag")
        } catch {
            print("Autocomplete error: \(error)")
        }
    }
    
    func applySuggestion(_ suggestion: AutocompleteSuggestion) {
        self.query = suggestion.properties.formatted ?? ""
        self.suggestions = []
    }
    
    func positionDriversAround(_ coord: CLLocationCoordinate2D) {
        let drivers = DriverInfoData.all
        
        // Gi hver sjåfør en tilfeldig posisjon rundt søkepunktet
        let positioned = drivers.map { driver -> DriverInfo in
            var d = driver
            
            let latOffset = Double.random(in: -0.01...0.01)
            let lonOffset = Double.random(in: -0.01...0.01)
            
            d.latitude = coord.latitude + latOffset
            d.longitude = coord.longitude + lonOffset
            
            return d
        }
        
        self.drivers = positioned
        print("🚕 \(drivers.count) sjåfører plassert rundt \(coord)")
    }
    
    func placeAllDriversAround(coord: CLLocationCoordinate2D) {
        var result: [DriverInfo] = []
        
        for driver in DriverInfoData.all {
            var d = driver
            // Litt random offset så de ikke ligger oppå hverandre
            d.latitude  = coord.latitude  + Double.random(in: -0.01...0.01)
            d.longitude = coord.longitude + Double.random(in: -0.01...0.01)
            result.append(d)
        }
        
        self.drivers = result
    }
    
    func buildDriversFromPlaces() {
        print("🏁 buildDriversFromPlaces() startet")
        print("Antall places:", places.count)

        var available = DriverInfoData.all
        available.shuffle()

        guard !available.isEmpty else {
            self.drivers = []
            return
        }

        // Hvis places er tomt: vis ALLE drivere rundt brukerens senter
        if places.isEmpty {
            print("⚠️ Ingen places funnet – viser alle drivere rundt regionen")

            // Sett ALLE drivere til kartets senter
            let center = CLLocationCoordinate2D(latitude: 63.4305, longitude: 10.3951) // Trondheim default

            let updated = DriverInfoData.all.map { driver -> DriverInfo in
                var d = driver
                d.latitude = center.latitude + Double.random(in: -0.01...0.01)
                d.longitude = center.longitude + Double.random(in: -0.01...0.01)
                return d
            }

            self.drivers = updated
            return
        }

        // 🔥 Hvis places finnes → match drivere til places
        let count = min(places.count, available.count)
        var slicedDrivers = Array(available.prefix(count))
        let slicedPlaces = Array(places.prefix(count))

        for i in 0..<count {
            let coord = slicedPlaces[i].geometry.coordinate
            slicedDrivers[i].latitude = coord.latitude
            slicedDrivers[i].longitude = coord.longitude
        }

        self.drivers = slicedDrivers
    }
    
    func fetchPlaces(lat: Double, lon: Double, category: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await apiService.fetchPlaces(
                lat: lat,
                lon: lon,
                category: category
            )

            self.places = result

            // ❗️❗️ ESSENSIELT: Uten denne får du ALDRI driverpins ❗️❗️
            self.buildDriversFromPlaces()

        } catch {
            self.errorMessage = "Kunne ikke hente steder"
            self.places = []
            self.drivers = []
        }

        isLoading = false
    }
    
    func placeDriversAround(coord: CLLocationCoordinate2D) {
        var result: [DriverInfo] = []
        
        for driver in DriverInfoData.all {
            var d = driver
            d.latitude  = coord.latitude  + Double.random(in: -0.01...0.01)
            d.longitude = coord.longitude + Double.random(in: -0.01...0.01)
            result.append(d)
        }

        self.drivers = result
    }
    
    
}
