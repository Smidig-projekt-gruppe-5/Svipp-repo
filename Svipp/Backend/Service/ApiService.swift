import Foundation

class ApiService {
    
    private var apiKey: String {
        // API nøkkel
        guard let key = Bundle.main.infoDictionary?["GEOAPIFY_API_KEY"] as? String else {
            fatalError("Fant ikke API_KEY for api tilgang")
        }
        return key
    }
    

    // henter steder som vi bruker som sjåfører !!!
    func fetchPlaces(
        lat: Double,
        lon: Double,
        category: String,
        radius: Int = 5000
    ) async throws -> [PlaceFeature] {
        
        let urlString =
        "https://api.geoapify.com/v2/places?categories=\(category)&filter=circle:\(lon),\(lat),\(radius)&limit=20&apiKey=\(apiKey)"
        
   
        
        guard let url = URL(string: urlString) else {
            print(" Ugyldig URL for API Places: \(urlString)")
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let http = response as? HTTPURLResponse {
                print(" HTTP status:", http.statusCode)
            }
            
            let decoded = try JSONDecoder().decode(PlaceResponse.self, from: data)
          
            
            return decoded.features
        } catch {
            print(" ApiService.fetchPlaces feilet:", error)
            throw error
        }
    }
}
