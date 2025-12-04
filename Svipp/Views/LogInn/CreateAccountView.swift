import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var birthdate: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                Image("Svipp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .padding(.bottom, 8)
                
                VStack(spacing: 4) {
                    Text("Lag Bruker")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Text("Fyll inn informasjonen under for å opprette en konto")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 12) {
                    TextField("Fullt navn", text: $name)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    TextField("Fødselsdato (DD.MM.ÅÅÅÅ)", text: $birthdate)
                        .keyboardType(.numbersAndPunctuation)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    SecureField("Passord", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                
                if let errorMessage = authService.authError {
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                SecondaryButton(
                    text: authService.isLoading ? "Oppretter konto..." : "Opprett konto"
                ) {
                    if authService.isLoading { return }
                    authService.createAccount(
                        name: name,
                        birthdate: birthdate,
                        email: email,
                        password: password
                    )
                }
                .disabled(name.isEmpty || email.isEmpty || password.isEmpty || authService.isLoading)
                
                Spacer()
                
                Text("Ved å opprette konto godtar du våre Terms of Service og Privacy Policy")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
            }
        }
        .onChange(of: authService.user) { newUser in
            // Hvis bruker ble opprettet -> lukk create-account view
            if newUser != nil {
                dismiss()
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(AuthService.shared)
    }
}
