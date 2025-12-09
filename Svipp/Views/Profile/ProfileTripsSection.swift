import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

// Fjerne ^ før levering


struct ProfileTripsSection: View {
    let drivers: [DriverInfo]
    @Binding var favoriteDriverIDs: Set<String>
    let currentUserName: String
    let onSelectTrip: (DriverInfo) -> Void
    
    var body: some View {
        let sortedDrivers = drivers.sorted {
            ($0.lastTripDate ?? .distantPast) > ($1.lastTripDate ?? .distantPast)
        }

        let ratedDrivers: [(driver: DriverInfo, myRating: Int)] = sortedDrivers.compactMap { driver in
            if let myRating = driver.ratingGivenBy(userName: currentUserName) {
                return (driver, myRating)
            } else {
                return nil
            }
        }
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Tidligere turer")
                .font(.headline)
                .foregroundColor(Color("SvippTextColor"))
                .padding(.horizontal)

            VStack(spacing: 12) {
                if ratedDrivers.isEmpty {
                    Text("Du har ikke vurdert noen sjåfører ennå")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ForEach(ratedDrivers, id: \.driver.id) { item in
                        let driver = item.driver
                        let myRating = item.myRating
                        let ratingToShow = String(myRating)

                        Button {
                            // 👇 når brukeren trykker på kortet
                            onSelectTrip(driver)
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                
                                DriverCard(
                                    name: driver.name,
                                    rating: ratingToShow,
                                    address: driver.address,
                                    yearsExperience: driver.experienceDisplay,
                                    price: driver.price,
                                    imageName: driver.imageName,
                                    showPriceLabel: false
                                )
                                .background(Color(red: 0.98, green: 0.96, blue: 0.90))
                                .cornerRadius(18)
                                .shadow(radius: 2, y: 1)

                                Button {
                                    toggleFavorite(for: driver)
                                } label: {
                                    Image(systemName: favoriteDriverIDs.contains(driver.id) ? "heart.fill" : "heart")
                                        .font(.system(size: 20))
                                        .foregroundColor(
                                            favoriteDriverIDs.contains(driver.id) ? .red : .gray
                                        )
                                        .padding(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .buttonStyle(.plain)   // så det ser ut som et vanlig kort, ikke blå knapp
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 4)
    }
    
    private func toggleFavorite(for driver: DriverInfo) {
        if favoriteDriverIDs.contains(driver.id) {
            favoriteDriverIDs.remove(driver.id)
        } else {
            favoriteDriverIDs.insert(driver.id)
        }
    }
}


#Preview {
    StatefulPreviewWrapper(Set<String>()) { binding in
        ScrollView {
            ProfileTripsSection(
                drivers: DriverInfoData.all,
                favoriteDriverIDs: binding,
                currentUserName: "Lise",
                onSelectTrip: { _ in }   // 👈 preview: gjør ingenting
            )
        }
    }
}
