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
        // Last inn sjåfører ved oppstart
        loadDrivers()
    }
    
    // MARK: - Last inn sjåfører fra DriverInfoData
    func loadDrivers() {
        // Hent ALLE hardkodede sjåfører fra DriverInfoData
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
    
    // MARK: - Bygg sjåfører tilknyttet places
    func buildDriversFromPlaces() {
        // Bruk ALLE hardkodede sjåfører fra DriverInfoData
        var available = DriverInfoData.all
        
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
