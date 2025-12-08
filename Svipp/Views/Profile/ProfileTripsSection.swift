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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tidligere turer")
                .font(.headline)
                .foregroundColor(Color("SvippTextColor"))
                .padding(.horizontal)

            VStack(spacing: 12) {
                if drivers.isEmpty {
                    Text("Ingen turer enda")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ForEach(drivers) { driver in
                        ZStack(alignment: .topTrailing) {

                            DriverCard(
                                name: driver.name,
                                rating: driver.rating,
                                address: driver.address,
                                yearsExperience: driver.experienceDisplay,
                                price: driver.price,
                                imageName: driver.imageName,
                                showPriceLabel: false     // 👈 skjul "Pris"
                            )

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
                favoriteDriverIDs: binding
            )
        }
    }
}
