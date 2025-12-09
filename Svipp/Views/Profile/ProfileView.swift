import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var showFavorites = false
    @State private var favoriteDriverIDs: Set<String> = []
    
    @State private var showReceipt = false
    @State private var selectedDriverForReceipt: DriverInfo? = nil

    private var favoriteDrivers: [DriverInfo] {
        authService.previousDrivers.filter { favoriteDriverIDs.contains($0.id) }
    }
      
    var body: some View {
        let profile = authService.currentUserProfile
          
        VStack(spacing: 0) {
            ProfileTopBar {
                showFavorites = true
            }
              
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ProfileHeader(profile: profile)
                      
                    Divider().padding(.horizontal)
                      
                    if let profile {
                        ProfileInfoSection(profile: profile)
                          
                        ProfileTripsSection(
                            drivers: authService.previousDrivers,
                            favoriteDriverIDs: $favoriteDriverIDs,
                            currentUserName: profile.name
                        ) { driver in
                            selectedDriverForReceipt = driver
                            showReceipt = true          // 👈 Dette trigges riktig
                        }
                    }

                    Spacer(minLength: 0)
                    ProfileLogoutButton()
                }
            }
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesModalView(
                isPresented: $showFavorites,
                favoriteDrivers: favoriteDrivers
            )
        }
        // 👇 LEGG TIL DENNE
        .sheet(isPresented: $showReceipt) {
            if let driver = selectedDriverForReceipt {
                ReceiptView(
                    total: driver.price,
                    paymentMethod: "Visa *1234",
                    dateString: driver.lastTripFormatted
                )
                .environmentObject(authService)   // arver same AuthService
            } else {
                Text("Kunne ikke laste kvittering")
            }
        }
        .onAppear {
            if let uid = authService.user?.uid,
               authService.currentUserProfile == nil {
                authService.loadUserProfile(uid: uid)
            }
            authService.loadPreviousDrivers()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView().environmentObject(AuthService.shared)
    }
}
