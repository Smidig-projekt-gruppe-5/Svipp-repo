import SwiftUI
import FirebaseAuth

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Group {
            if authService.user == nil {
                // Ikke innlogget → vis login
                NavigationStack {
                    LogInView()
                }
            } else {
                // Innlogget → vis hoved-appen (Explore som default)
                MainView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthService.shared)
}
