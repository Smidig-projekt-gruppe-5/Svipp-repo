import Foundation
import CoreLocation

struct DriverInfo: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let rating: String
    let address: String
    let experienceYears: Int?
    let totalTrips: Int?

    let price: String
    let imageName: String
    let lastTripAt: String

    // ekstra info til profilview
    let age: Int?
    let employmentDate: String?
    let tripCount: Int?
    let about: String?
    let reviews: [DriverReview]?

    // kordinater for kartet
    var latitude: Double? = nil
    var longitude: Double? = nil

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude ?? 0,
            longitude: longitude ?? 0
        )
    }

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
        reviews: [DriverReview]? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
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
        self.latitude = latitude
        self.longitude = longitude
    }

    // tekst til sjåfør turer
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

// ekstra helpers
extension DriverInfo {
    func ratingGivenBy(userName: String) -> Int? {
        reviews?.first(where: { $0.reviewerName == userName }).map {
            Int($0.rating.rounded())
        }
    }

    var lastTripDate: Date? {
        ISO8601DateFormatter().date(from: lastTripAt)
    }

    var lastTripFormatted: String {
        guard let date = lastTripDate else { return "" }
        let out = DateFormatter()
        out.dateFormat = "dd.MM.yyyy HH:mm"
        return out.string(from: date)
    }
}

// sample data brukes til sjåfører
enum DriverInfoData {

    static let all: [DriverInfo] = [

        DriverInfo(
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
                DriverReview(reviewerName: "Lise", reviewerAge: 28, rating: 5.0, comment: "Veldig trygg og behagelig tur!", createdAt: nil),
                DriverReview(reviewerName: "Arne", reviewerAge: 41, rating: 4.5, comment: "Presis og hyggelig, anbefales.", createdAt: nil),
                DriverReview(reviewerName: "Mona", reviewerAge: 35, rating: 4.0, comment: "Kom litt sent, men veldig god kjøring.", createdAt: nil)
            ]
        ),

        DriverInfo(
            name: "Ahmed Ali",
            rating: "4.9",
            address: "Oslo, Tøyen 12",
            experienceYears: 3,
            totalTrips: 410,
            price: "590 kr",
            imageName: "Ahmed",
            lastTripAt: "2025-11-28T09:30:00Z",
            age: 52,
            employmentDate: "2021",
            tripCount: 410,
            about: "Ahmed har kjørt for Svipp siden 2021. Han er kjent for presisjon og trygg kjøring, og passer spesielt for passasjerer som liker rolig stemning.",
            reviews: [
                DriverReview(reviewerName: "Elias Roth", reviewerAge: 29, rating: 5.0, comment: "Veldig profesjonell og hyggelig.", createdAt: nil),
                DriverReview(reviewerName: "Sofia Lund", reviewerAge: 34, rating: 5.0, comment: "Trygg kjøring og god stemning.", createdAt: nil),
                DriverReview(reviewerName: "Henrik Moe", reviewerAge: 52, rating: 4.5, comment: "Kom litt sent, men veldig behagelig tur.", createdAt: nil)
            ]
        ),

        DriverInfo(
            name: "Sara Hansen",
            rating: "4.7",
            address: "Oslo, Majorstuen 8",
            experienceYears: 1,
            totalTrips: 120,
            price: "520 kr",
            imageName: "Sara",
            lastTripAt: "2025-11-30T18:15:00Z",
            age: 29,
            employmentDate: "2024",
            tripCount: 120,
            about: "Sara liker å møte nye mennesker og sørger alltid for en behagelig og trygg reiseopplevelse.",
            reviews: [
                DriverReview(reviewerName: "Nora Wessel", reviewerAge: 22, rating: 5.0, comment: "Superhyggelig sjåfør!", createdAt: nil),
                DriverReview(reviewerName: "Thomas Bråten", reviewerAge: 47, rating: 4.0, comment: "Effektiv og ryddig.", createdAt: nil),
                DriverReview(reviewerName: "Emilie Foss", reviewerAge: 31, rating: 5.0, comment: "Kommer til å velge henne igjen.", createdAt: nil)
            ]
        ),

        DriverInfo(
            name: "Jonas Berg",
            rating: "4.9",
            address: "Oslo, Grünerløkka 33",
            experienceYears: 4,
            totalTrips: 680,
            price: "610 kr",
            imageName: "Jonas",
            lastTripAt: "2025-11-25T14:45:00Z",
            age: 37,
            employmentDate: "2020",
            tripCount: 680,
            about: "Jonas er kjent for god lokalkunnskap og finner alltid de mest effektive rutene i byen.",
            reviews: [
                DriverReview(reviewerName: "Aksel Nygaard", reviewerAge: 38, rating: 5.0, comment: "Utrolig smooth kjøring.", createdAt: nil),
                DriverReview(reviewerName: "Helene Vik", reviewerAge: 27, rating: 5.0, comment: "Super service!", createdAt: nil),
                DriverReview(reviewerName: "Martin Bråthen", reviewerAge: 33, rating: 4.0, comment: "God sjåfør selv i mye trafikk.", createdAt: nil)
            ]
        ),

        DriverInfo(
            name: "Fatima Noor",
            rating: "5.0",
            address: "Oslo, Bjørvika 19",
            experienceYears: 2,
            totalTrips: 310,
            price: "600 kr",
            imageName: "Fatima",
            lastTripAt: "2025-11-29T20:10:00Z",
            age: 27,
            employmentDate: "2023",
            tripCount: 310,
            about: "Fatima setter komfort og trygghet først, og er spesielt populær på kveldsturer.",
            reviews: [
                DriverReview(reviewerName: "Oskar Hansen", reviewerAge: 33, rating: 5.0, comment: "Fantastisk sjåfør!", createdAt: nil),
                DriverReview(reviewerName: "Selma Nystrøm", reviewerAge: 21, rating: 5.0, comment: "Favoritten min!", createdAt: nil),
                DriverReview(reviewerName: "Håkon Kristoffersen", reviewerAge: 48, rating: 4.5, comment: "Veldig bra kjøring.", createdAt: nil)
            ]
        )
    ]
}
