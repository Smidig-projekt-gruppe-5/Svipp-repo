import SwiftUI


struct ProfileLogoutButton: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Button(action: {
            authService.signOut()
        }) {
            Text("Logg ut")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.4), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}
