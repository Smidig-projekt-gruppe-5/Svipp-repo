import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var showFavorites = false
    @State private var favoriteDriverIDs: Set<String> = []   // ❤️ favoritter

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
                    }

                    ProfileTripsSection(
                        drivers: authService.previousDrivers,
                        favoriteDriverIDs: $favoriteDriverIDs
                    )
                    
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
            .presentationDetents([.fraction(0.65)])     // 25% lavere modal
            .presentationDragIndicator(.visible)
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
