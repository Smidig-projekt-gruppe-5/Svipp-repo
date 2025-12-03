import SwiftUI
import MapKit

struct ExploreView: View {
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    
    // Modal-states
    @State private var showDriverList = false
    @State private var showDriverOrder = false
    @State private var selectedDriver: DriverInfo? = nil

    // Kart-region – her satt til Oslo sentrum
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack(alignment: .top) {

            //  KART I BAKGRUNN
            Map(coordinateRegion: $region)
                .ignoresSafeArea()

            //  OVERLAY MED SØK + KNAPP
            VStack(spacing: 12) {
                ExploreSearch(
                    fromText: $fromText,
                    toText: $toText,
                    onSearch: {
                        print("Søk på \(toText)")
                    },
                    onBooking: {
                        print("Booking trykket")
                    },
                    onFilter: {
                        print("Filter trykket")
                    }
                )

                Button {
                    withAnimation(.easeInOut) {
                        showDriverList = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "car.fill")
                        Text("Simuler sjåfør")
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule().fill(Color(red: 0.47, green: 0.70, blue: 0.72))
                    )
                    .foregroundColor(.white)
                    .padding(.top, 6)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            //  Zoom inn/ut-knapper
            MapZoomControls(region: $region, bottomPadding: 100)

            //  DRIVERLIST – første modal (velg sjåfør)
            DriverList(
                isPresented: $showDriverList,
                onSelect: { driver in
                    selectedDriver = driver
                    showDriverList = false
                    
                    // liten delay så det ikke "blinker" ved bytte
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.easeInOut) {
                            showDriverOrder = true
                        }
                    }
                }
            )

            //  DRIVERORDER – andre modal (bestill tur)
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    driver: selectedDriver
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
