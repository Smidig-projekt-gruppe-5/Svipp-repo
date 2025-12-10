import SwiftUI

struct DriverList: View {
    @Binding var isPresented: Bool
    var onSelect: (DriverInfo) -> Void
    
    @EnvironmentObject var authService: AuthService
    
    @State private var sortMode: DriverSortMode = .distance
    @State private var selectedDriverForProfile: DriverInfo?
    @State private var showDriverProfile = false
    
    var body: some View {
        Modal(
            isPresented: $isPresented,
            title: "Tilgjengelige sjåfører",
            heightFraction: 0.75   // juster om du vil
        ) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    
                    // Filter-knapp
                    HStack {
                        DriverFilterMenu(selectedMode: $sortMode)
                        Spacer()
                    }
                    .padding(.top, 4)
                    
                    if authService.previousDrivers.isEmpty {
                        Text("Ingen sjåfører tilgjengelig enda")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    } else {
                        let sortedDrivers = DriverFilter.sort(
                            drivers: authService.previousDrivers,
                            by: sortMode
                        )
                        
                        ForEach(sortedDrivers) { driver in
                            DriverCard(
                                name: driver.name,
                                rating: driver.rating,
                                address: driver.address,
                                yearsExperience: driver.experienceDisplay,
                                price: driver.price,
                                imageName: driver.imageName,
                                onTapDetails: {
                                    // Les mer → åpne profil
                                    selectedDriverForProfile = driver
                                    showDriverProfile = true
                                }
                            )
                            .onTapGesture {
                                // Trykk på kortet → velg sjåfør (bestilling)
                                withAnimation(.easeInOut) {
                                    onSelect(driver)
                                    isPresented = false
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 90)
            }
        }
        .sheet(isPresented: $showDriverProfile) {
            if let driver = selectedDriverForProfile {
                DriverProfileView(driver: driver)
                    .presentationDetents([.fraction(0.75), .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            authService.loadPreviousDrivers()
        }
    }
}

#Preview {
    DriverList(isPresented: .constant(true)) { _ in }
        .environmentObject(AuthService.shared)
        .background(Color.gray.opacity(0.3))
}
