import SwiftUI

struct DriverList: View {
    @Binding var isPresented: Bool
    var onSelect: (DriverInfo) -> Void
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Modal(
            isPresented: $isPresented,
            title: "Tilgjengelige sjåfører",
            heightFraction: 0.9
        ) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    
                    if authService.previousDrivers.isEmpty {
                        Text("Ingen sjåfører tilgjengelig enda")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    } else {
                        ForEach(authService.previousDrivers) { driver in
                            Button {
                                withAnimation(.easeInOut) {
                                    onSelect(driver)
                                    isPresented = false
                                }
                            } label: {
                                DriverCard(
                                    name: driver.name,
                                    rating: driver.rating,
                                    address: driver.address,
                                    yearsExperience: driver.experienceDisplay,
                                    price: driver.price,
                                    imageName: driver.imageName
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 90)
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
