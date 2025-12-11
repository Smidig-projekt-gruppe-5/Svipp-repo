import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var showFavorites = false
    @State private var favoriteDriverIDs: Set<String> = []
    @State private var selectedDriverForReceipt: DriverInfo? = nil
    
    private var favoriteDrivers: [DriverInfo] {
        authService.previousDrivers.filter { favoriteDriverIDs.contains($0.id) }
    }
    
    var body: some View {
        let profile = authService.currentUserProfile
        
        VStack(spacing: 0) {
            // top bar med knapp for favoritter
            ProfileTopBar {
                showFavorites = true
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ProfileHeader(profile: profile)
                    
                    Divider().padding(.horizontal)
                    
                    if let profile {
                        ProfileInfoSection(profile: profile)
                        
                        ProfileBookingsSection(
                            bookings: authService.bookings,
                            onDelete: { booking in
                                authService.deleteBooking(booking)
                            }
                        )
                        
                        //  Tidligere turer, rating, favoritter, kvittering
                        ProfileTripsSection(
                            drivers: authService.previousDrivers,
                            favoriteDriverIDs: $favoriteDriverIDs,
                            currentUserName: profile.name
                        ) { driver in
                            selectedDriverForReceipt = driver
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
        .sheet(item: $selectedDriverForReceipt) { driver in
            ReceiptView(
                total: driver.price,
                paymentMethod: "Visa *1234",
                dateString: driver.lastTripFormatted
            )
            .environmentObject(authService)
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
