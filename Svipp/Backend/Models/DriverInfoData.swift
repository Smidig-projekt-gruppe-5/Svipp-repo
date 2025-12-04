//Sjoførene har antall turerer på yearsOfExperience, men også en egen tripCount, endre dette?//

import Foundation

struct DriverInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
    let age: Int?
    let employmentDate: String?
    let tripCount: Int?
    let about: String?
    let reviews: [DriverReview]?
}

struct DriverReview: Identifiable, Equatable {
    let id = UUID()
    let reviewerName: String
    let reviewerAge: Int
    let rating: Int
    let comment: String?
}

enum DriverSamples {
    static let all: [DriverInfo] = [
        DriverInfo(
            name: "Tom Nguyen",
            rating: "4.8",
            address: "Oslo, Gamlebyen 54",
            yearsExperience: "2 år – 235 turer",
            price: "555 kr",
            imageName: "Tom",
            
            age: 34,
            employmentDate: "10.02.2023",
            tripCount: 235,
            about: "Jeg heter Tom og har kjørt for Svipp siden 2023. Jeg er opptatt av trygg, rolig og forutsigbar kjøring. Mange av passasjerene mine sier at jeg skaper en behagelig stemning i bilen, og jeg liker alltid å slå av en hyggelig prat dersom du ønsker det. På fritiden er jeg glad i foto og å utforske nye steder i Oslo.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Ahmed Ali",
            rating: "4.9",
            address: "Oslo, Tøyen 12",
            yearsExperience: "3 år – 410 turer",
            price: "590 kr",
            imageName: "Ahmed",
            age: 52,
            employmentDate: "07.01.2021",
            tripCount: 410,
            about: "Jeg heter Ahmed og har jobbet som sjåfør i over tre år. For meg handler god transport om punktlighet, respekt og god service. Jeg er vant til både korte og lange turer i Oslo, og får ofte skryt for tålmodighet og trygg kjøring. Når jeg ikke er på veien, liker jeg å lage mat og bruke tid med familien.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Sara Hansen",
            rating: "4.7",
            address: "Oslo, Majorstuen 8",
            yearsExperience: "1 år – 120 turer",
            price: "520 kr",
            imageName: "Sara",
            age: 25,
            employmentDate: "24.05.2023",
            tripCount: 120,
            about: "Jeg heter Sara og har vært sjåfør hos Svipp siden 2023. Jeg elsker jobben min fordi jeg får møte nye mennesker hver dag. Jeg kjører alltid rolig og hensynsfullt, og sørger for at passasjerene mine føler seg trygge og ivaretatt. Utenfor jobb trener jeg mye og er glad i å gå turer i marka.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Jonas Berg",
            rating: "4.9",
            address: "Oslo, Grünerløkka 33",
            yearsExperience: "4 år – 680 turer",
            price: "610 kr",
            imageName: "Jonas",
            age: 32,
            employmentDate: "10.02.2023",
            tripCount: 680,
            about: "Jeg heter Jonas og har kjørt profesjonelt i flere år. Jeg kjenner Oslo godt og liker å finne de raskeste og mest effektive rutene for å gi en behagelig tur. Jeg liker å holde bilen ren og ryddig, og får ofte gode tilbakemeldinger på service og profesjonalitet. Ellers er jeg veldig glad i musikk og sport.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Helene Larsen",
            rating: "4.6",
            address: "Oslo, St. Hanshaugen 21",
            yearsExperience: "2 år – 260 turer",
            price: "545 kr",
            imageName: "Helene",
            age: 34,
            employmentDate: "10.02.2023",
            tripCount: 260,
            about: "Jeg heter Helene og har jobbet som sjåfør i litt over to år. Jeg kombinerer effektiv kjøring med god service, og jeg er opptatt av at turen skal være komfortabel og stressfri. Jeg trives godt i jobben min og liker å bidra til positive opplevelser for passasjerene mine. På fritiden liker jeg å trene og tilbringe tid med venner.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Marius Olsen",
            rating: "4.8",
            address: "Oslo, Nydalen 5",
            yearsExperience: "3 år – 390 turer",
            price: "575 kr",
            imageName: "Marius",
            age: 34,
            employmentDate: "10.02.2022",
            tripCount: 390,
            about: "Jeg heter Marius og har kjørt for Svipp i tre år. Jeg er kjent for å være rolig bak rattet og for god kommunikasjon med passasjerene mine. Jeg liker å sørge for en sikker, behagelig tur – enten det er korte byturer eller lengre strekninger. På fritiden er jeg glad i gaming og fotball.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Fatima Noor",
            rating: "5.0",
            address: "Oslo, Bjørvika 19",
            yearsExperience: "2 år – 310 turer",
            price: "600 kr",
            imageName: "Fatima",
            age: 29,
            employmentDate: "10.02.2023",
            tripCount: 310,
            about: "Jeg heter Fatima og elsker fleksibiliteten og menneskemøtene jobben gir. Jeg setter sikkerhet høyt, og mange beskriver meg som vennlig, presis og omsorgsfull. Jeg liker å holde en positiv tone i bilen og strekker meg alltid litt ekstra for å gi en god opplevelse. På fritiden studerer jeg og trener yoga.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        ),
        DriverInfo(
            name: "Erik Johansen",
            rating: "4.5",
            address: "Oslo, Holmlia 44",
            yearsExperience: "5 år – 820 turer",
            price: "530 kr",
            imageName: "Erik",
            age: 34,
            employmentDate: "09.01.2020",
            tripCount: 820,
            about: "Jeg heter Erik og har vært sjåfør i over fem år. Jeg har kjørt alt fra arbeidsturer til nattkjøring og kjenner Oslo som min egen lomme. Jeg legger stor vekt på sikkerhet, god flyt i trafikken og profesjonell oppførsel. Når jeg ikke kjører, liker jeg å mekke på bil og tilbringe tid i naturen.",
            reviews: [
                DriverReview(reviewerName: "Anette Sørensen", reviewerAge: 25, rating: 5, comment: nil) //Her kan vi legge til skreven review
            ]
        )
    ]
}
