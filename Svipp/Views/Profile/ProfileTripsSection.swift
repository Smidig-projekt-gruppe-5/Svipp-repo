import SwiftUI

struct ProfileTripsSection: View {
    let drivers: [DriverInfo]
    @Binding var favoriteDriverIDs: Set<String>
    let currentUserName: String
    let onSelectTrip: (DriverInfo) -> Void
    
    var body: some View {
        // Sorter på siste tur
        let sortedDrivers = drivers.sorted {
            ($0.lastTripDate ?? .distantPast) > ($1.lastTripDate ?? .distantPast)
        }
        
        // Kun sjåfører som denne brukeren faktisk har gitt rating til
        let ratedDrivers: [DriverInfo] = sortedDrivers.filter {
            $0.ratingGivenBy(userName: currentUserName) != nil
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
                    ForEach(ratedDrivers) { driver in
                        let myRating = driver.ratingGivenBy(userName: currentUserName) ?? 0
                        let ratingToShow = String(myRating)
                        
                        ZStack(alignment: .center) {
                            DriverCard(
                                name: driver.name,
                                rating: ratingToShow,
                                address: driver.address,
                                yearsExperience: driver.experienceDisplay,
                                price: driver.price,
                                imageName: driver.imageName,
                                showPriceLabel: false,
                                onTapDetails: {
                                    onSelectTrip(driver)
                                },
                                showDetailsButton: false,
                                rightPaddingForPrice: 30
                            )
                            
                            .background(Color(red: 0.98, green: 0.96, blue: 0.90))
                            .cornerRadius(18)
                            .shadow(radius: 2, y: 1)
                            .onTapGesture {
                                onSelectTrip(driver)
                            }
                            
                            Button {
                                toggleFavorite(for: driver)
                            } label: {
                                Image(systemName: favoriteDriverIDs.contains(driver.id) ? "heart.fill" : "heart")
                                    .font(.system(size: 25))
                                    .foregroundColor(
                                        favoriteDriverIDs.contains(driver.id) ? .red : .gray
                                    )
                                    .padding(12)
                            }
                            .buttonStyle(.plain)
                        }
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
