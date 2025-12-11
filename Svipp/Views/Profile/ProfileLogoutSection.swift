import SwiftUI


struct ProfileLogoutButton: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Button(action: {
            authService.signOut()
        }) {
            Text("Logg ut")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                )
                .padding(.horizontal)
                .padding(.bottom, 50)
        }
    }
}
