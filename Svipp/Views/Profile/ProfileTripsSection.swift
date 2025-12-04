import SwiftUI


struct ProfileTripsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tidligere turer")
                .font(.headline)
                .foregroundColor(Color("SvippTextColor"))
                .padding(.horizontal)
            
            VStack(spacing: 20) {
                DriverCard(
                    name: "Natasha Brun",
                    rating: "4.6",
                    address: "Oslo sentrum",
                    yearsExperience: "3 år som sjåfør – 180 turer",
                    price: "",
                    imageName: "Tom"
                )
            }
            .padding(.horizontal)
        }
        .padding(.top, 4)
    }
}
