import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var birthdate: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var addressLine: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    
    @State private var carMake: String = ""
    @State private var carModel: String = ""
    @State private var carYear: String = ""
    
    @State private var isSaving: Bool = false
    @State private var localError: String?
    
    var body: some View {
        let profile = authService.currentUserProfile
        
        Form {
            Section(header: Text("Personlig informasjon")) {
                TextField("Navn", text: $name)
                
                TextField("Fødselsdato (DD.MM.ÅÅÅÅ)", text: $birthdate)
                    .keyboardType(.numbersAndPunctuation)
                
                if let email = profile?.email {
                    HStack {
                        Text("E-post")
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                    }
                }
                
                TextField("Telefonnummer", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Adresse")) {
                TextField("Adresse", text: $addressLine)
                TextField("Postnummer", text: $postalCode)
                    .keyboardType(.numberPad)
                TextField("By", text: $city)
            }
            
            Section(header: Text("Bil")) {
                TextField("Bilmerke (f.eks. Toyota)", text: $carMake)
                TextField("Modell (f.eks. Corolla)", text: $carModel)
                TextField("Årsmodell (f.eks. 2018)", text: $carYear)
                    .keyboardType(.numberPad)
            }
            
            if let localError = localError {
                Section {
                    Text(localError)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            
            Section {
                Button {
                    saveChanges()
                } label: {
                    if isSaving {
                        HStack {
                            ProgressView()
                            Text("Lagrer…")
                        }
                    } else {
                        Text("Lagre endringer")
                    }
                }
                .disabled(isSaving || name.isEmpty || birthdate.isEmpty)
            }
        }
        .navigationTitle("Rediger profil")
        .onAppear {
            if let p = profile {
                name = p.name
                birthdate = p.birthdate
                phoneNumber = p.phoneNumber ?? ""
                addressLine = p.addressLine ?? ""
                postalCode = p.postalCode ?? ""
                city = p.city ?? ""
                carMake = p.carMake ?? ""
                carModel = p.carModel ?? ""
                carYear = p.carYear ?? ""
            }
        }
    }
    
    private func saveChanges() {
        isSaving = true
        localError = nil
        
        authService.updateUserProfile(
            name: name,
            birthdate: birthdate,
            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
            addressLine: addressLine.isEmpty ? nil : addressLine,
            postalCode: postalCode.isEmpty ? nil : postalCode,
            city: city.isEmpty ? nil : city,
            carMake: carMake.isEmpty ? nil : carMake,
            carModel: carModel.isEmpty ? nil : carModel,
            carYear: carYear.isEmpty ? nil : carYear
        ) { error in
            DispatchQueue.main.async {
                isSaving = false
                if let error = error {
                    localError = error.localizedDescription
                } else {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environmentObject(AuthService.shared)
    }
}
