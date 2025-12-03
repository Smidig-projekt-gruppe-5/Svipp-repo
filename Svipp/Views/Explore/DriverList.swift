import SwiftUI

struct DriverList: View {
    @Binding var isPresented: Bool
    var onSelect: (DriverInfo) -> Void
    
    private let drivers = DriverSamples.all
    
    var body: some View {
        Modal(
            isPresented: $isPresented,
            title: "Tilgjengelige sjåfører",
            heightFraction: 0.9
        ) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(drivers) { driver in
                        Button {
                            withAnimation(.easeInOut) {
                                onSelect(driver)
                            }
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
    }
}

#Preview {
    DriverList(isPresented: .constant(true)) { _ in }
        .background(Color.gray.opacity(0.3))
}
