import Foundation
import SwiftUI
import CoreLocation

@MainActor
class ExploreViewModel: ObservableObject {
    
    @Published var lastSearchCoordinate: CLLocationCoordinate2D?
    @Published var query: String = ""
    @Published var suggestions: [AutocompleteSuggestion] = []
    @Published var places: [PlaceFeature] = []
    @Published var drivers: [DriverInfo] = [] // sjåfører !!!
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let autocompleteService = AutocompleteService()
    private let apiService = ApiService()
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
        loadDrivers()
    }
    
    // default sjåfører (fra infodata )
    func loadDrivers() {
        self.drivers = DriverInfoData.all
    }
    
    // autocomplete
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
    
    func placeAllDriversAround(coord: CLLocationCoordinate2D) {
        lastSearchCoordinate = coord
        
        Task {
            await fetchPlaces(
                lat: coord.latitude,
                lon: coord.longitude,
                category: "catering.cafe" // gjøres om til sjåfører
            )
        }
    }
    
    // henter sjåfører med fallback
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
            self.buildDriversFromPlaces(anchorIfEmpty: anchor)
            
        } catch {
            print("ExploreViewModel.fetchPlaces feilet:", error)
            self.errorMessage = "Kunne ikke hente steder"
            self.places = []
            self.buildDriversFromPlaces(anchorIfEmpty: anchor)
        }
        
        isLoading = false
    }
    
    // lag sjåfører av places
    func buildDriversFromPlaces(anchorIfEmpty: CLLocationCoordinate2D? = nil) {
        
        var available = DriverInfoData.all
        available.shuffle()
        
        guard !available.isEmpty else {
            self.drivers = []
            return
        }
        
        // hvis places er tomt? spre sjåfører rundt et punkt
        if places.isEmpty {
            let center: CLLocationCoordinate2D
            
            if let anchorIfEmpty {
                center = anchorIfEmpty
            } else if let last = lastSearchCoordinate {
                center = last
            } else {
                center = CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522)// fallback  (oslo)

            }
            
            let updated = available.map { driver -> DriverInfo in
                var d = driver
                d.latitude = center.latitude + Double.random(in: -0.01...0.01)
                d.longitude = center.longitude + Double.random(in: -0.01...0.01)
                return d
            }
            
            self.drivers = updated
            print("places tomt -> bruk fallback... \(updated.count) sjåfører spredd rundt \(center)")
            return
        }
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
}
