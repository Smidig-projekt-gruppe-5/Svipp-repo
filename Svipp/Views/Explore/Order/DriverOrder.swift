import SwiftUI

// Lite ikon + tittel + verdi-rad
private struct InfoRow: View {
    let systemImage: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct DriverOrder: View {
    @Binding var isPresented: Bool
    @Binding var showDriverList: Bool
    @Binding var showPickUp: Bool
    
    let driver: DriverInfo
    
    private let pickupAddress = "Byporten 76"
    private let dropoffAddress = "Ekebergsletta 23"
    private let etaText = "5–8 minutter fra din posisjon"
    private let estimatedTime = "Ca. 18 min kjøretid"
    private let paymentMethod = "Kort • **** 1234"
    
    var body: some View {
        Modal(
            isPresented: $isPresented,
            heightFraction: 0.9
        ) {
            ZStack(alignment: .top) {
                
                // Alt innhold
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        // Sjåfør-header
                        DriverSummaryCard(
                            name: driver.name,
                            rating: driver.rating,
                            address: driver.address,
                            yearsExperience: driver.experienceDisplay,   // 👈 ny
                            price: driver.price,
                            imageName: driver.imageName
                        )
                        .padding(.horizontal)
                        
                        // Turinfo-boks
                        SvippCard {
                            VStack(spacing: 14) {
                                Text("Turinformasjon")
                                    .font(.title3)
                                    .bold()
                                
                                Text("\(driver.name) er klar til å hente deg.\n\(etaText)")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                
                                Divider()
                                
                                VStack(spacing: 12) {
                                    InfoRow(
                                        systemImage: "mappin.and.ellipse",
                                        title: "Hentested",
                                        value: pickupAddress
                                    )
                                    
                                    InfoRow(
                                        systemImage: "flag.checkered",
                                        title: "Leveringssted",
                                        value: dropoffAddress
                                    )
                                    
                                    InfoRow(
                                        systemImage: "clock",
                                        title: "Estimert tid",
                                        value: estimatedTime
                                    )
                                    
                                    InfoRow(
                                        systemImage: "creditcard",
                                        title: "Betaling",
                                        value: paymentMethod
                                    )
                                    
                                    InfoRow(
                                        systemImage: "coloncurrencysign.circle",
                                        title: "Nok",
                                        value: driver.price
                                    )
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 90)
                    }
                    // plass under top-bar med tilbake + bestill
                    .padding(.top, 30)
                }
                
                // Topp bar: Tilbake-knapp + Bestill-knapp
                HStack {
                    // Tilbake
                    Button {
                        withAnimation(.easeInOut) {
                            isPresented = false
                            showDriverList = true
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("SvippAccent"))
                            .padding(10)
                            .background(Color("SvippMainColor"))
                            .clipShape(Circle())
                            .shadow(radius: 3, y: 1)
                    }
                    
                    Spacer()
                    
                    // Bestill (capsule)
                    Button {
                        print("Bestiller tur med \(driver.name)")
                        withAnimation(.easeInOut) {
                            
                            // lukk ordremodalen
                            isPresented = false
                            
                            // ikke vis driverlista
                            showDriverList = false
                            
                            // vis pickup-skjermen
                            showPickUp = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Bestill")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .foregroundColor(Color("SvippAccent"))
                        .background(
                            Capsule()
                                .fill(Color("SvippMainColor"))
                        )
                        .shadow(radius: 3, y: 1)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 90)
            }
        }
    }
}
