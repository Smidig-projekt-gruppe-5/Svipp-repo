import SwiftUI
import MapKit

struct ExploreView: View {
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    @State private var showFilter = false
    
    // Modal-states
    @State private var showDriverList = false
    @State private var showDriverOrder = false
    @State private var showPickUp = false
    @State private var showTripCompleted = false       // 👈 NY!
    @State private var selectedDriver: DriverInfo? = nil

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack(alignment: .top) {

            // Bakgrunnskart
            Map(coordinateRegion: $region)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ExploreSearch(
                    fromText: $fromText,
                    toText: $toText,
                    onSearch: {},
                    onBooking: {}
                )

                Button {
                    withAnimation { showDriverList = true }
                } label: {
                    HStack {
                        Image(systemName: "car.fill")
                        Text("Simuler sjåfør")
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color(red: 0.47, green: 0.70, blue: 0.72)))
                    .foregroundColor(.white)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            MapZoomControls(region: $region, bottomPadding: 100)
                .zIndex(0)

            // Første modal – velg sjåfør
            DriverList(
                isPresented: $showDriverList,
                onSelect: { driver in
                    selectedDriver = driver
                    showDriverList = false

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation {
                            showDriverOrder = true
                        }
                    }
                  
                }
            )
            .zIndex(1)

            // Andre modal – bestill
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    showPickUp: $showPickUp,
                    driver: selectedDriver
                )
                .zIndex(2)
            }

            // Tredje skjerm – sjåfør på vei
            if let selectedDriver, showPickUp {
                PickUpModal(
                    isPresented: $showPickUp,
                    driver: selectedDriver,
                    pinCode: "4279",
                    showTripCompleted: $showTripCompleted  // 👈 NY
                )
                .transition(.move(edge: .bottom))
                .zIndex(3)
            }
        }
        .fullScreenCover(isPresented: $showTripCompleted) {
            TripCompleted(isPresented: $showTripCompleted)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
