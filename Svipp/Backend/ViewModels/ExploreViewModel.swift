import Foundation
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    
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
    
    func loadDrivers() {
        // Hent ALLE hardkodede sjåfører
        self.drivers = DriverInfoData.all
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
    
    func buildDriversFromPlaces() {
        var available = DriverInfoData.all
        
        guard !available.isEmpty else {
            self.drivers = []
            return
        }
        
        available.shuffle()
        
        let count = min(places.count, available.count)
        
        let sliced = Array(available.prefix(count))
        
        self.drivers = sliced
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
            
            self.buildDriversFromPlaces()
            
        } catch {
            print("Feil ved henting av steder:", error)
            self.errorMessage = "Kunne ikke hente sjåfører. Prøv igjen."
            self.places = []
            self.drivers = []
        }
        
        isLoading = false
    }
}
