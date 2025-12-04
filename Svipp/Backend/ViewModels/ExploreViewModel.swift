//
//  ExploreViewModel.swift
//  Svipp
//
//  Created by Hannan Moussa on 03/12/2025.
//

import Foundation
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var suggestions: [AutocompleteSuggestion] = []
   
    //Fra API
    @Published var places: [PlaceFeature] = []

    //Sjåfører som skal vises
    @Published var drivers: [DriverInfo] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let autocompleteService = AutocompleteService()
    private let apiService = ApiService()

    //Forslag fra autocomplete
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
    
    //Sjåfører fra places
       func buildDriversFromPlaces() {
           // Tilfeldig sjåfør
           var shuffled = DriverSamples.all.shuffled()

           //Antall sjåfører skal matche antall steder fra API
           let count = min(places.count, shuffled.count)

           //Klipp listen slik at de matcher
           shuffled = Array(shuffled.prefix(count))

           //Resultatet
           self.drivers = shuffled
       }

    // Henter steder
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
            
            //places - sjåfør
            self.buildDriversFromPlaces( )

        } catch {
            self.errorMessage = "Kunne ikke hente sjåfører. Prøv igjen."
        }

        isLoading = false
    }
}
