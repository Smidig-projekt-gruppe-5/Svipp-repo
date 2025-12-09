import SwiftUI
import MapKit
import CoreLocation

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
    
    @State private var showBooking = false
    @State private var bookingDate = Date()
    @State private var showBookingConfirmation = false
    
    @StateObject private var viewModel = ExploreViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - KART MED DRIVER-PINS
            Map(
                coordinateRegion: $region,
                annotationItems: viewModel.drivers
            ) { driver in
                MapAnnotation(
                    coordinate: driver.coordinate
                ) {
                    DriverPin(
                        imageName: driver.imageName,
                        priceText: driver.price
                    ) {
                        selectedDriver = driver
                        showDriverList = true
                    }
                    .zIndex(1000)
                }
            }
            .ignoresSafeArea()
            .zIndex(0)
            
            
            // MARK: - SØK + AUTOCOMPLETE
            VStack(spacing: 12) {
                ExploreSearch(
                    fromText: $fromText,
                    toText: $toText,
                    onSearch: {
                        // Skjul rullegardin
                        viewModel.suggestions = []
                        
                        // Hvis du trykker søk uten å velge -> bruk autocomplete query som posisjon?
                        // men enklest: bare åpne sjåførliste
                        withAnimation { showDriverList = true }
                    },
                    onBooking: { showBooking = true },
                    suggestions: viewModel.suggestions,
                    onSelectSuggestion: handleSelect,
                    onClearSuggestions: {
                        viewModel.suggestions = []
                    }
                )
                .onChange(of: toText) { newValue in
                    if ignoreAutocomplete { return }     // ← stopp auto-søk
                    viewModel.query = newValue
                    Task { await viewModel.searchAutocomplete() }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .zIndex(10)
            
            
            // MARK: - ZOOM-KNAPPER (TILBAKE!)
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
            
            
            // MARK: - BESTILLINGSMODAL
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    showPickUp: $showPickUp,
                    driver: selectedDriver
                )
                .zIndex(30)
            }
            
            
            // MARK: - SJÅFØR PÅ VEI
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
        
        
        // MARK: - BOOKING ALERT
        .alert("Booking bekreftet", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Vi har mottatt bookingen din. Du finner den under profilen din.")
        }
        
        
        .onAppear {
            viewModel.loadDrivers()
        }
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

        // 🚕 Vis sjåfører rundt søket
        viewModel.placeAllDriversAround(coord: coord)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(AuthService.shared)
    }
}
