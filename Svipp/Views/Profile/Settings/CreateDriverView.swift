import SwiftUI
import UIKit

struct CreateDriverView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var rating: String = ""
    @State private var address: String = ""
    
    @State private var experienceYears: String = ""
    @State private var totalTrips: String = ""
    
    @State private var price: String = ""
    @State private var imageName: String = "Tom"
    
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        Form {
            Section("Sjåførinfo") {
                TextField("Navn", text: $name)
                
                TextField("Rating (f.eks. 4.8)", text: $rating)
                    .keyboardType(.decimalPad)
                
                TextField("Adresse (f.eks. Oslo, Majorstuen 8)", text: $address)
            }
            
            Section("Erfaring") {
                HStack {
                    TextField("År (f.eks. 3)", text: $experienceYears)
                        .keyboardType(.numberPad)
                    Text("år")
                }
                
                HStack {
                    TextField("Antall turer (f.eks. 180)", text: $totalTrips)
                        .keyboardType(.numberPad)
                    Text("turer")
                }
            }
            
            Section("Pris") {
                TextField("Pris (f.eks. 550 kr)", text: $price)
                    .keyboardType(.numbersAndPunctuation)
            }
            
            Section("Bilde") {
                TextField("Bildenavn i Assets (f.eks. Tom)", text: $imageName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                HStack {
                    Text("Forhåndsvisning:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    if let uiImage = UIImage(named: imageName), !imageName.isEmpty {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                        
                        Text("Fant ikke bilde med dette navnet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            
            Section {
                Button {
                    saveDriver()
                } label: {
                    if isSaving {
                        HStack {
                            ProgressView()
                            Text("Lagrer…")
                        }
                    } else {
                        Text("Lagre sjåfør")
                    }
                }
                .disabled(
                    isSaving ||
                    name.isEmpty ||
                    rating.isEmpty ||
                    address.isEmpty
                )
            }
        }
        .navigationTitle("Ny sjåfør")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveDriver() {
        errorMessage = nil
        isSaving = true
        
        let formatter = ISO8601DateFormatter()
        let nowString = formatter.string(from: Date())
        
        let yearsInt = Int(experienceYears)
        let tripsInt = Int(totalTrips)
        
        let driver = DriverInfo(
            id: UUID().uuidString,
            name: name,
            rating: rating,
            address: address,
            experienceYears: yearsInt,
            totalTrips: tripsInt,
            price: price,
            imageName: imageName.isEmpty ? "Tom" : imageName,
            lastTripAt: nowString
        )
        
        authService.addPreviousDriver(driver) { error in
            DispatchQueue.main.async {
                isSaving = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateDriverView()
            .environmentObject(AuthService.shared)
    }
}
