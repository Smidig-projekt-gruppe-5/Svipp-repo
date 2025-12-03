//
//  LogInView.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Top spacing
                    Spacer().frame(height: 40)
                    
                    // Logo
                    Image("Svipp")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .padding(.bottom, 8)
                    
                    // Tittel + undertekst
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
                    
                    // E-post + passord
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
                    
                    // Fortsett-knapp
                    SecondaryButton(text: "Fortsett") {
                        // Login handler
                    }
                    
                    // Divider med "or"
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
                    
                    // BankID / Vipps
                    VStack{
                        TertiaryButton(text: "Logg inn med BankID", iconName: "BankID") {
                            //BankID Handler
                        }
                        
                        TertiaryButton(text: "Logg inn med Vipps", iconName: "Vipps") {
                            //BankID Handler
                        }
                        
                        NavigationLink {
                            CreateAccountView()
                        } label: {
                            ZStack{
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
                            .background(Color(.sRGB,
                                              red: 0.933,
                                              green: 0.933,
                                              blue: 0.933,
                                             opacity: 1)
                            )
                            .cornerRadius(14)
                            .padding(.horizontal, 16)
                        }
                    }
                    // Terms / Privacy nederst
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
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
