//
//  AutocompleteService.swift
//  Svipp
//
//  Created by Hannan Moussa on 03/12/2025.
//

import Foundation

class AutocompleteService {

    private var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["GEOAPIFY_API_KEY"] as? String else {
            fatalError("Fant ikke API-nøkkel")
        }
        return key
    }

    func autocomplete(query: String) async throws -> [AutocompleteSuggestion] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=\(encodedQuery)&limit=5&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else
        {
            print("Ugyldig URL for AutocompleteService: \(urlString)")
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(AutocompleteResponse.self, from: data)
        
        return decoded.features
    }
}
