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
    let driver: DriverInfo
    
    // Midlertidige dummy-verdier
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
            ZStack(alignment: .topLeading) {
                
                // Alt innhold
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        DriverSummaryCard(
                            name: driver.name,
                            rating: driver.rating,
                            address: driver.address,
                            yearsExperience: driver.yearsExperience,
                            price: driver.price,
                            imageName: driver.imageName
                        )
                        .padding(.horizontal)
                        
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
                                    InfoRow(systemImage: "mappin.and.ellipse",
                                            title: "Hentested",
                                            value: pickupAddress)
                                    
                                    InfoRow(systemImage: "flag.checkered",
                                            title: "Leveringssted",
                                            value: dropoffAddress)
                                    
                                    InfoRow(systemImage: "clock",
                                            title: "Estimert tid",
                                            value: estimatedTime)
                                    
                                    InfoRow(systemImage: "creditcard",
                                            title: "Betaling",
                                            value: paymentMethod)
                                    
                                    InfoRow(systemImage: "coloncurrencysign.circle",
                                            title: "Pris",
                                            value: driver.price)
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        
                        Button {
                            print("Bestiller tur med \(driver.name)")
                            withAnimation(.easeInOut) {
                                isPresented = false
                            }
                        } label: {
                            Text("Bestill tur")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color("SvippMainColor"))
                                )
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 80)
                    }
                    .padding(.top, 32)
                }
                
                // TILBAKE-KNAPP
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
                .padding(.leading, 16)
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    DriverOrder(
        isPresented: .constant(true),
        showDriverList: .constant(false),
        driver: DriverInfo(
            name: "Tom Nguyen",
            rating: "4.8",
            address: "Oslo, Gamlebyen 54",
            yearsExperience: "2 år – 235 turer",
            price: "555 kr",
            imageName: "Tom"
        )
    )
}
