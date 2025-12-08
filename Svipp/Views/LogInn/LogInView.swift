import SwiftUI
import SwiftUI

struct LogInView: View {
    @EnvironmentObject var authService: AuthService   // 🔐 Firebase auth
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                Image("Svipp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .padding(.bottom, 8)
                
                VStack(spacing: 4) {
                    Text("Logg Inn")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Text("Skriv inn din E-post og passord for å logge inn")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
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
                
                SecondaryButton(text: authService.isLoading ? "Logger inn..." : "Fortsett") {
                    if authService.isLoading { return }
                    authService.signIn(email: email, password: password)
                }
                .disabled(email.isEmpty || password.isEmpty || authService.isLoading)
                
                if authService.isLoading {
                    ProgressView()
                        .tint(Color("SvippMainColor"))
                }
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("or")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal, 24)
                
                VStack {
                    TertiaryButton(text: "Logg inn med BankID", iconName: "BankID") {
                        // TODO: BankID handler
                    }
                    
                    TertiaryButton(text: "Logg inn med Vipps", iconName: "Vipps") {
                        // TODO: Vipps handler
                    }
                    
                    NavigationLink {
                        CreateAccountView()
                    } label: {
                        ZStack {
                            Text("Lag Bruker")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color("SvippTextColor"))
                            
                            HStack {
                                Spacer()
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            Color(
                                .sRGB,
                                red: 0.933,
                                green: 0.933,
                                blue: 0.933,
                                opacity: 1
                            )
                        )
                        .cornerRadius(14)
                        .padding(.horizontal, 16)
                    }
                }
                
                Text("Ved å trykke fortsett godtar du våre Terms of Service og Privacy Policy")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
            }
        }
    }
}
