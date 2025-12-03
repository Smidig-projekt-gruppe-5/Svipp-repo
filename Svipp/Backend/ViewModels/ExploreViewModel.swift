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
    @Published var places: [PlaceFeature] = []

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

        } catch {
            self.errorMessage = "Kunne ikke hente steder"
        }

        isLoading = false
    }
}
