import Foundation

struct DriverInfo: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let rating: String
    let address: String
    
    /// Antall år som sjåfør (kan være nil)
    let experienceYears: Int?
    
    /// Antall turer totalt (kan være nil)
    let totalTrips: Int?
    
    let price: String
    let imageName: String
    let lastTripAt: String
    
    // Ekstra info til profilview
    let age: Int?
    let employmentDate: String?
    let tripCount: Int?
    let about: String?
    let reviews: [DriverReview]?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        rating: String,
        address: String,
        experienceYears: Int? = nil,
        totalTrips: Int? = nil,
        price: String,
        imageName: String,
        lastTripAt: String,
        age: Int? = nil,
        employmentDate: String? = nil,
        tripCount: Int? = nil,
        about: String? = nil,
        reviews: [DriverReview]? = nil
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
        self.age = age
        self.employmentDate = employmentDate
        self.tripCount = tripCount
        self.about = about
        self.reviews = reviews
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

// MARK: - Preview / test-data

extension DriverInfo {
    static let previewDriver = DriverInfo(
        name: "Tom Nguyen",
        rating: "4.8",
        address: "Oslo, Gamlebyen 54",
        experienceYears: 2,
        totalTrips: 235,
        price: "555 kr",
        imageName: "Tom",
        lastTripAt: "2025-12-01T12:00:00Z",
        age: 32,
        employmentDate: "2022",
        tripCount: 235,
        about: "Tom er en rolig og hyggelig sjåfør som har kjørt i Oslo i flere år. Han er spesielt godt likt av pendlere og studenter.",
        reviews: [
            DriverReview(
                reviewerName: "Lise",
                reviewerAge: 28,
                rating: 5.0,
                comment: "Veldig trygg og behagelig tur!",
                createdAt: nil
            ),
            DriverReview(
                reviewerName: "Arne",
                reviewerAge: 41,
                rating: 4.5,
                comment: "Presis og hyggelig, anbefales.",
                createdAt: nil
            ),
            DriverReview(
                reviewerName: "Mona",
                reviewerAge: 35,
                rating: 4.0,
                comment: "Kom litt sent, men veldig god kjøring.",
                createdAt: nil
            )
        ]
    )
}
