import Foundation

struct DriverInfo: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let rating: String
    let address: String
    
    /// Antall år som sjåfør (kan være nil for gamle data)
    let experienceYears: Int?
    
    /// Antall turer totalt (kan være nil)
    let totalTrips: Int?
    
    let price: String
    let imageName: String
    let lastTripAt: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        rating: String,
        address: String,
        experienceYears: Int?,
        totalTrips: Int?,
        price: String,
        imageName: String,
        lastTripAt: String
    ) {
        self.id = id
        self.name = name
        self.rating = rating
        self.address = address
        self.experienceYears = experienceYears
        self.totalTrips = totalTrips
        self.price = price
        self.imageName = imageName
        self.lastTripAt = lastTripAt
    }
    
    /// Tekst til UI, f.eks. "3 år – 180 turer"
    var experienceDisplay: String {
        switch (experienceYears, totalTrips) {
        case let (y?, t?):
            return "\(y) år – \(t) turer"
        case let (y?, nil):
            return "\(y) år"
        case let (nil, t?):
            return "\(t) turer"
        default:
            return ""
        }
    }
}
