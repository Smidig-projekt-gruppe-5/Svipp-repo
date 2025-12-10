import SwiftUI
import MapKit
import CoreLocation

// MARK: - MapPoint med STABIL ID (fikser flicker)
private struct MapPoint: Identifiable {
    enum Kind {
        case user
        case driver(DriverInfo)
    }

    let id: String
    let coordinate: CLLocationCoordinate2D
    let kind: Kind
}

struct ExploreView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var ignoreAutocomplete = false
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    
    @State private var showDriverList = false
    @State private var showDriverOrder = false
    @State private var showPickUp = false
    @State private var showTripCompleted = false
    @State private var selectedDriver: DriverInfo? = nil
    @State private var hasCenteredOnUser = false

    @State private var showBooking = false
    @State private var bookingDate = Date()
    @State private var showBookingConfirmation = false
    
    @StateObject private var viewModel = ExploreViewModel()
    @StateObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // 🔹 Sist posisjon vi oppdaterte sjåfører for
    @State private var lastDriversUpdateCenter: CLLocationCoordinate2D? = nil
    
    // MARK: - STABILE MAP-ANNOTATIONS
    private var mapPoints: [MapPoint] {
        var items: [MapPoint] = []

        // 👤 Bruker-posisjon
        if let userCoord = locationManager.userLocation {
            items.append(
                MapPoint(
                    id: "user-location",
                    coordinate: userCoord,
                    kind: .user
                )
            )
        }

        // 🚕 Sjåfører
        for driver in viewModel.drivers {
            items.append(
                MapPoint(
                    id: driver.id,
                    coordinate: driver.coordinate,
                    kind: .driver(driver)
                )
            )
        }

        return items
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - KART MED STABILE PINS
            Map(
                coordinateRegion: $region,
                annotationItems: mapPoints
            ) { point in
                MapAnnotation(coordinate: point.coordinate) {
                    switch point.kind {

                    case .user:
                        UserPin()
                            .zIndex(2000)

                    case .driver(let driver):
                        DriverPin(
                            imageName: driver.imageName,
                            priceText: driver.price
                        ) {
                            selectedDriver = driver
                            showDriverList = true
                        }
                        .scaleEffect(0.8) // litt mindre pin
                        .zIndex(1000)
                    }
                }
            }
            .ignoresSafeArea()
            .zIndex(0)
            
            // MARK: - SØK
            VStack(spacing: 12) {
                ExploreSearch(
                    fromText: $fromText,
                    toText: $toText,
                    onSearch: {
                        viewModel.suggestions = []
                        withAnimation { showDriverList = true }
                    },
                    onBooking: { showBooking = true },
                    suggestions: viewModel.suggestions,
                    onSelectSuggestion: handleSelect,
                    onClearSuggestions: { viewModel.suggestions = [] }
                )
                .onChange(of: toText) { newValue in
                    if ignoreAutocomplete { return }
                    viewModel.query = newValue
                    Task { await viewModel.searchAutocomplete() }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .zIndex(10)
            
            // MARK: - ZOOM-KONTROLLER
            MapZoomControls(region: $region, bottomPadding: 100)
                .zIndex(5)
            
            // MARK: - DRIVERLISTE
            DriverList(
                isPresented: $showDriverList,
                onSelect: { driver in
                    selectedDriver = driver
                    showDriverList = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation { showDriverOrder = true }
                    }
                }
            )
            .zIndex(20)
            
            // MARK: - DRIVER ORDER
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    showPickUp: $showPickUp,
                    driver: selectedDriver
                )
                .zIndex(30)
            }
            
            // MARK: - PICK-UP VIEW
            if let selectedDriver, showPickUp {
                PickUpModal(
                    isPresented: $showPickUp,
                    driver: selectedDriver,
                    pinCode: "4279",
                    showTripCompleted: $showTripCompleted
                )
                .transition(.move(edge: .bottom))
                .zIndex(40)
            }
        }
        
        // MARK: - BOOKING SHEET
        .sheet(isPresented: $showBooking) {
            BookingView(
                fromAddress: fromText,
                toAddress: toText,
                bookingDate: $bookingDate
            ) { from, to, info in
                _ = authService.addBooking(
                    from: from,
                    to: to,
                    pickupTime: bookingDate
                )
                
                showBooking = false
                showBookingConfirmation = true
            }
        }
        
        // MARK: - TRIP COMPLETED
        .fullScreenCover(isPresented: $showTripCompleted) {
            if let driver = selectedDriver {
                TripCompleted(isPresented: $showTripCompleted, driver: driver)
            } else {
                Text("Noe gikk galt – fant ikke sjåfør")
            }
        }
        
        // MARK: - ALERT
        .alert("Booking bekreftet", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Vi har mottatt bookingen din. Du finner den under profilen din.")
        }
        
        .onAppear {
            viewModel.loadDrivers()
            lastDriversUpdateCenter = region.center
        }

        // 👇 OPPDATER SJÅFØRER KONTROLLERT NÅR DU FLYTTER PÅ KARTET
        .onChange(of: region.center.latitude) { _ in
            let center = region.center
            if shouldUpdateDrivers(for: center) {
                lastDriversUpdateCenter = center
                viewModel.placeAllDriversAround(coord: center)
            }
        }

        // MARK: - CENTER KARTET PÅ BRUKER KUN 1 GANG
        .onChange(of: locationManager.userLocation?.latitude) { _ in
            guard let coord = locationManager.userLocation else { return }
            guard !hasCenteredOnUser else { return }

            hasCenteredOnUser = true
            lastDriversUpdateCenter = coord
            withAnimation {
                region.center = coord
            }
        }
    }
    
    // MARK: - Bare oppdater sjåfører hvis kartet har flyttet seg "nok"
    private func shouldUpdateDrivers(for newCenter: CLLocationCoordinate2D) -> Bool {
        guard let last = lastDriversUpdateCenter else { return true }
        
        let lastLoc = CLLocation(latitude: last.latitude, longitude: last.longitude)
        let newLoc = CLLocation(latitude: newCenter.latitude, longitude: newCenter.longitude)
        let distance = lastLoc.distance(from: newLoc) // i meter
        
        // Bare oppdater hvis vi har flyttet mer enn 500 meter
        return distance > 800
    }
    
    private func handleSelect(_ suggestion: AutocompleteSuggestion) {
        toText = suggestion.properties.formatted ?? ""
        viewModel.suggestions = []

        let coord = suggestion.geometry.coordinate

        withAnimation {
            region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }

        // 🚕 Vis sjåfører rundt søket + oppdater "last"
        lastDriversUpdateCenter = coord
        viewModel.placeAllDriversAround(coord: coord)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(AuthService.shared)
    }
}
