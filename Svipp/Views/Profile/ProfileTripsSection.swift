import SwiftUI

struct ProfileTripsSection: View {
    let drivers: [DriverInfo]
    
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
                        DriverCard(
                            name: driver.name,
                            rating: driver.rating,
                            address: driver.address,
                            yearsExperience: driver.experienceDisplay,
                            price: driver.price,
                            imageName: driver.imageName
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 4)
    }
}

#Preview {
    ScrollView {
        ProfileTripsSection(drivers: [])
    }
}
