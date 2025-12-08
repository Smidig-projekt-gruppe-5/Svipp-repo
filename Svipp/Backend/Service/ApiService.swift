//
//  ApiService.swift
//  Svipp
//
//  Created by Hannan Moussa on 03/12/2025.
//

import Foundation

class ApiService
{
    
    private var apiKey: String
    {
        //API nøkkel
        guard let key = Bundle.main.infoDictionary?["GEOAPIFY_API_KEY"] as? String else
        {
            fatalError("Fant ikke API_KEY for api tilgang")
        }
        return key
    }
    
    //Innhentign av steder basert på
    func fetchPlaces(
        lat: Double,
        lon: Double,
        category: String,
        radius: Int = 5000
    )
    
    async throws -> [PlaceFeature]
    {
        //Generer API URL
        let urlString =
        "https://api.geoapify.com/v2/places?categories=\(category)&filter=circle:\(lon),\(lat),\(radius)&limit=20&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else
        {
            print("Ugyldig URL for API Places: \(urlString)")
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(PlaceResponse.self, from: data)
        
        return decoded.features
    }
}
