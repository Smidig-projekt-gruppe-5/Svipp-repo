import Foundation

struct DriverInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
}

enum DriverSamples {
    static let all: [DriverInfo] = [
        DriverInfo(
            name: "Tom Nguyen",
            rating: "4.8",
            address: "Oslo, Gamlebyen 54",
            yearsExperience: "2 år – 235 turer",
            price: "555 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Ahmed Ali",
            rating: "4.9",
            address: "Oslo, Tøyen 12",
            yearsExperience: "3 år – 410 turer",
            price: "590 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Sara Hansen",
            rating: "4.7",
            address: "Oslo, Majorstuen 8",
            yearsExperience: "1 år – 120 turer",
            price: "520 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Jonas Berg",
            rating: "4.9",
            address: "Oslo, Grünerløkka 33",
            yearsExperience: "4 år – 680 turer",
            price: "610 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Helene Larsen",
            rating: "4.6",
            address: "Oslo, St. Hanshaugen 21",
            yearsExperience: "2 år – 260 turer",
            price: "545 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Marius Olsen",
            rating: "4.8",
            address: "Oslo, Nydalen 5",
            yearsExperience: "3 år – 390 turer",
            price: "575 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Fatima Noor",
            rating: "5.0",
            address: "Oslo, Bjørvika 19",
            yearsExperience: "2 år – 310 turer",
            price: "600 kr",
            imageName: "Tom"
        ),
        DriverInfo(
            name: "Erik Johansen",
            rating: "4.5",
            address: "Oslo, Holmlia 44",
            yearsExperience: "5 år – 820 turer",
            price: "530 kr",
            imageName: "Tom"
        )
    ]
}
