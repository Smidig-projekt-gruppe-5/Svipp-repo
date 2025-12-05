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
    
    // 🔑 Henter lagrede sjåfører fra AuthService
    private let authService: AuthService
    
    init(authService: AuthService = .shared) {
        self.authService = authService
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
            print("Autocomplete error: \(error)")
        }
    }
    
    // MARK: - Bygg sjåfører tilknyttet places
    func buildDriversFromPlaces() {
        // Bruk bare sjåfører som faktisk er lagret for brukeren
        var available = authService.previousDrivers
        
        guard !available.isEmpty else {
            self.drivers = []
            return
        }
        
        available.shuffle()
        
        // Antall sjåfører skal matche antall steder fra API
        let count = min(places.count, available.count)
        
        // Klipp listen slik at de matcher
        let sliced = Array(available.prefix(count))
        
        // Resultatet
        self.drivers = sliced
    }
    
    // MARK: - Hent steder + match med sjåfører
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
            
            // places → sjåfører
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
