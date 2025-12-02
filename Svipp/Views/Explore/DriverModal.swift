import SwiftUI

struct DriverModal: View {
    @Binding var isPresented: Bool

    private let drivers = [
        ("Tom Nguyen", "4.8", "Oslo, gamlebyen 54", "2 år – 235 turer", "555kr", "Tom"),
        ("Tom Nguyen", "4.8", "Oslo, gamlebyen 54", "2 år – 235 turer", "555kr", "Tom")
    ]

    var body: some View {
        Modal(isPresented: $isPresented, title: "Tilgjengelige sjåfører", heightFraction: 0.6) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(Array(drivers.enumerated()), id: \.offset) { _, d in
                        DriverCard(
                            name: d.0,
                            rating: d.1,
                            address: d.2,
                            yearsExperience: d.3,
                            price: d.4,
                            imageName: d.5
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}



#Preview {
    DriverModal(isPresented: .constant(true))
}
