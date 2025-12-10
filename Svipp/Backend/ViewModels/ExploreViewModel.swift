import Foundation
import SwiftUI
import CoreLocation

@MainActor
class ExploreViewModel: ObservableObject {
    
    // Sist sentrum vi brukte for å oppdatere sjåfører
    @Published var lastSearchCoordinate: CLLocationCoordinate2D?
    
    @Published var query: String = ""
    @Published var suggestions: [AutocompleteSuggestion] = []
    
    // Fra Geoapify Places API
    @Published var places: [PlaceFeature] = []
    
    // Sjåfører som vises i Explore
    @Published var drivers: [DriverInfo] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let autocompleteService = AutocompleteService()
    private let apiService = ApiService()
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
        loadDrivers()
    }
    
    // MARK: - Default sjåfører (uten posisjon – posisjon settes senere)
    func loadDrivers() {
        self.drivers = DriverInfoData.all
    }
    
    // MARK: - Autocomplete
    func searchAutocomplete() async {
        guard !query.isEmpty else {
            suggestions = []
            return
        }
        
        do {
            let result = try await autocompleteService.autocomplete(query: query)
            self.suggestions = result
        } catch {
            print("Autocomplete error:", error)
        }
    }
    
    func applySuggestion(_ suggestion: AutocompleteSuggestion) {
        self.query = suggestion.properties.formatted ?? ""
        self.suggestions = []
    }
    
    // MARK: - Kalles fra ExploreView når kart-senteret endres eller søk velges
    func placeAllDriversAround(coord: CLLocationCoordinate2D) {
        lastSearchCoordinate = coord
        
        Task {
            await fetchPlaces(
                lat: coord.latitude,
                lon: coord.longitude,
                category: "catering.cafe"   // kun kaféer
            )
        }
    }
    
    // MARK: - Hent places fra API (med fallback)
    func fetchPlaces(lat: Double, lon: Double, category: String) async {
        isLoading = true
        errorMessage = nil
        
        let anchor = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        do {
            let result = try await apiService.fetchPlaces(
                lat: lat,
                lon: lon,
                category: category
            )
            
            self.places = result
            print("📍 ExploreViewModel: places.count =", result.count)
            
            // Bygg sjåfører basert på places (eller fallback hvis tom)
            self.buildDriversFromPlaces(anchorIfEmpty: anchor)
            
        } catch {
            print("❌ ExploreViewModel.fetchPlaces feilet:", error)
            self.errorMessage = "Kunne ikke hente steder"
            
            // VIKTIG: ikke slett drivers – generer fallback i stedet
            self.places = []
            self.buildDriversFromPlaces(anchorIfEmpty: anchor)
        }
        
        isLoading = false
    }
    
    // MARK: - Lag sjåfører basert på places
    func buildDriversFromPlaces(anchorIfEmpty: CLLocationCoordinate2D? = nil) {
        print("🏁 buildDriversFromPlaces() – places:", places.count)
        
        var available = DriverInfoData.all
        available.shuffle()
        
        guard !available.isEmpty else {
            self.drivers = []
            return
        }
        
        // Hvis places er tomt: fallback → spre sjåfører rundt et ankerpunkt
        if places.isEmpty {
            let center: CLLocationCoordinate2D
            
            if let anchorIfEmpty {
                center = anchorIfEmpty
            } else if let last = lastSearchCoordinate {
                center = last
            } else {
                // fallback → Oslo sentrum
                center = CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522)
            }
            
            let updated = available.map { driver -> DriverInfo in
                var d = driver
                d.latitude = center.latitude + Double.random(in: -0.01...0.01)
                d.longitude = center.longitude + Double.random(in: -0.01...0.01)
                return d
            }
            
            self.drivers = updated
            print("⚠️ places tomt → bruk fallback, \(updated.count) sjåfører spredd rundt \(center)")
            return
        }
        
        // Vi har places → match drivere til places én-til-én
        let count = min(places.count, available.count)
        var slicedDrivers = Array(available.prefix(count))
        let slicedPlaces = Array(places.prefix(count))
        
        for i in 0..<count {
            let coord = slicedPlaces[i].geometry.coordinate
            slicedDrivers[i].latitude = coord.latitude
            slicedDrivers[i].longitude = coord.longitude
        }
        
        self.drivers = slicedDrivers
        print("✅ Matchet \(count) sjåfører til \(count) places fra API")
    }
}
