import SwiftUI
import UIKit   // 👈 trengs for UIImage

struct EditDriverView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    let driver: DriverInfo
    
    @State private var name: String
    @State private var rating: String
    @State private var address: String
    @State private var experienceYears: String
    @State private var totalTrips: String
    @State private var price: String
    @State private var imageName: String
    
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?
    
    init(driver: DriverInfo) {
        self.driver = driver
        _name = State(initialValue: driver.name)
        _rating = State(initialValue: driver.rating)
        _address = State(initialValue: driver.address)
        _experienceYears = State(initialValue: driver.experienceYears != nil ? String(driver.experienceYears!) : "")
        _totalTrips = State(initialValue: driver.totalTrips != nil ? String(driver.totalTrips!) : "")
        _price = State(initialValue: driver.price)
        _imageName = State(initialValue: driver.imageName)
    }
    
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
                
                // Liten preview
                HStack {
                    Text("Forhåndsvisning:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                HStack {
                    if let uiImage = UIImage(named: imageName), !imageName.isEmpty {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(systemName: "photo")   // 👈 trygg SF Symbol
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
                .disabled(isSaving || name.isEmpty || rating.isEmpty || address.isEmpty)
            }
        }
        .navigationTitle("Rediger sjåfør")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, 40)
    }
    
    private func saveChanges() {
        errorMessage = nil
        isSaving = true
        
        let yearsInt = Int(experienceYears)
        let tripsInt = Int(totalTrips)
        
        let updatedDriver = DriverInfo(
            id: driver.id,
            name: name,
            rating: rating,
            address: address,
            experienceYears: yearsInt,
            totalTrips: tripsInt,
            price: price,
            imageName: imageName.isEmpty ? "Tom" : imageName,
            lastTripAt: driver.lastTripAt
        )
        
        authService.updateDriver(updatedDriver) { error in
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
        EditDriverView(
            driver: DriverInfo(
                id: UUID().uuidString,
                name: "Test-sjåfør",
                rating: "4.8",
                address: "Oslo sentrum",
                experienceYears: 2,
                totalTrips: 200,
                price: "550 kr",
                imageName: "Tom",
                lastTripAt: "2025-12-03T10:00:00"
            )
        )
        .environmentObject(AuthService.shared)
    }
}
