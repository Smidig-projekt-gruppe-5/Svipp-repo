import SwiftUI

struct DriverList: View {
    @Binding var isPresented: Bool
    var onSelect: (DriverInfo) -> Void
    
    @State private var sortMode: DriverSortMode = .distance
    private let drivers = DriverSamples.all
    
    private var sortedDrivers: [DriverInfo] {
          DriverFilter.sort(drivers: drivers, by: sortMode)
      }
    
    var body: some View {
        Modal(
            isPresented: $isPresented,
            title: "Tilgjengelige sjåfører",
            heightFraction: 0.9
        ) {
            VStack(spacing: 12) {
                
                HStack {

                    
                  DriverFilterMenu(selectedMode: $sortMode)
                    Spacer()
                }
                .padding(.horizontal)
                
                // 🔹 LISTEN MED SJÅFØRER
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
}

#Preview {
    DriverList(
        isPresented: .constant(true),
        onSelect: { _ in },
    )
    .background(Color.gray.opacity(0.3))
}
