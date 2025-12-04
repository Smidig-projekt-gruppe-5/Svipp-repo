import SwiftUI
import PhotosUI
import UIKit

// MARK: - Hovedview

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        let profile = authService.currentUserProfile
        
        VStack(spacing: 0) {
            ProfileTopBar()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ProfileHeader(profile: profile)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    if let profile {
                        ProfileInfoSection(profile: profile)
                    }
                    
                    ProfileTripsSection()
                    
                    Spacer(minLength: 0)
                }
            }
            
            ProfileLogoutButton()
        }
        .padding(.bottom, 50)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            if let uid = authService.user?.uid,
               authService.currentUserProfile == nil {
                authService.loadUserProfile(uid: uid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthService.shared)
    }
}
