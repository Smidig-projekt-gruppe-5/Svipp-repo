import SwiftUI
import MapKit

struct ExploreView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    @State private var showFilter = false
    
    // Modal-states
    @State private var showDriverList = false
    @State private var showDriverOrder = false
    @State private var showPickUp = false
    @State private var showTripCompleted = false
    @State private var selectedDriver: DriverInfo? = nil
    
    // Booking
    @State private var showBooking = false
    @State private var bookingDate = Date()
    @State private var showBookingConfirmation = false

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
                    onSearch: {
                        guard !toText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            return
                        }
                        withAnimation {
                            showDriverList = true
                        }
                    },
                    onBooking: {
                        showBooking = true
                    }
                )

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
                    showTripCompleted: $showTripCompleted
                )
                .transition(.move(edge: .bottom))
                .zIndex(3)
            }
        }
        // Booking-sheet
        .sheet(isPresented: $showBooking) {
            BookingView(
                fromAddress: fromText,
                toAddress: toText,
                bookingDate: $bookingDate
            ) { from, to, info in
                // Her bruker du verdiene brukeren faktisk skrev inn
                _ = authService.addBooking(
                    from: from,
                    to: to,
                    pickupTime: bookingDate
                    // hvis du utvider modellen til å ha info/note kan du sende den også
                )
                
                showBooking = false
                showBookingConfirmation = true
            }
        }

        // Fullskjerm for tur fullført
        .fullScreenCover(isPresented: $showTripCompleted) {
            TripCompleted(isPresented: $showTripCompleted)
        }
        // Bekreftelses-alert etter booking
        .alert("Booking bekreftet", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Vi har mottatt bookingen din. Du finner den under profilen din.")
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(AuthService.shared)
    }
}
