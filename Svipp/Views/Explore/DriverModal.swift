import SwiftUI

struct DriverModal: View {
    @Binding var isPresented: Bool

    // Midlertidig dummy-data – kan byttes til ekte senere
    private let drivers: [(
        name: String,
        rating: String,
        address: String,
        yearsExperience: String,
        price: String,
        imageName: String
    )] = [
        ("Tom Nguyen", "4.8", "Oslo, gamlebyen 54", "2.år som sjåfør - 235 turer", "555kr", "Tom"),
        ("Tom Nguyen", "4.8", "Oslo, gamlebyen 54", "2.år som sjåfør - 235 turer", "555kr", "Tom"),
        ("Tom Nguyen", "4.8", "Oslo, gamlebyen 54", "2.år som sjåfør - 235 turer", "555kr", "Tom")
    ]

    var body: some View {
        GeometryReader { geometry in
            if isPresented {
                ZStack(alignment: .bottom) {
                    // Mørk bakgrunn bak modalen
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isPresented = false
                            }
                        }

                    // Selve modalen
                    VStack(spacing: 12) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 15)

                        Text("Tilgjengelige sjåfører")
                            .font(.headline)
                            .padding(.bottom, 4)

                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(drivers.enumerated()), id: \.offset) { _, driver in
                                    Button {
                                        // HER kan du åpne "bestilling modal" senere
                                        print("Valgte sjåfør: \(driver.name)")
                                    } label: {
                                        DriverCard(
                                            name: driver.name,
                                            rating: driver.rating,
                                            address: driver.address,
                                            yearsExperience: driver.yearsExperience,
                                            price: driver.price,
                                            imageName: driver.imageName
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 90)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6) // ca 2/3 av skjermen
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: isPresented)
                .ignoresSafeArea()

            }
        }
    }
}

#Preview {
    DriverModal(isPresented: .constant(true))
}
