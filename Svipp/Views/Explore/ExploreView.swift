import SwiftUI
import MapKit
import CoreLocation

private struct MapPoint: Identifiable {
    enum Kind {
        case user
        case driver(DriverInfo)
    }

    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let kind: Kind
}

struct ExploreView: View {
    @EnvironmentObject var authService: AuthService
    
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
    
    private var mapPoints: [MapPoint] {
        var items: [MapPoint] = []
        
        if let userCoord = locationManager.userLocation {
            items.append(MapPoint(coordinate: userCoord, kind: .user))
        }
        
        for driver in viewModel.drivers {
            items.append(MapPoint(coordinate: driver.coordinate, kind: .driver(driver)))
        }
        
        return items
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Kart
            Map(
                coordinateRegion: $region,
                annotationItems: mapPoints
            ) { point in
                MapAnnotation(coordinate: point.coordinate) {
                    switch point.kind {
                    case .user:
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .shadow(radius: 3)
                        
                    case .driver(let driver):
                        DriverPin(
                            imageName: driver.imageName,
                            priceText: driver.price
                        ) {
                            selectedDriver = driver
                            showDriverOrder = true
                        }
                        .zIndex(1000)
                    }
                }
            }
            .ignoresSafeArea()
            
            // MARK: - Søk + autocomplete
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
                    onSelectSuggestion: handleSelectSuggestion,
                    onClearSuggestions: {
                        viewModel.suggestions = []
                    }
                )
                .onChange(of: toText) { newValue in
                    viewModel.query = newValue
                    Task { await viewModel.searchAutocomplete() }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // MARK: - Zoom-knapper
            MapZoomControls(region: $region, bottomPadding: 120)
            
            // MARK: - Driverliste
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
            
            // MARK: - Bestilling
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    showPickUp: $showPickUp,
                    driver: selectedDriver
                )
            }
            
            // MARK: - Sjåfør på vei
            if let selectedDriver, showPickUp {
                PickUpModal(
                    isPresented: $showPickUp,
                    driver: selectedDriver,
                    pinCode: "4279",
                    showTripCompleted: $showTripCompleted
                )
                .transition(.move(edge: .bottom))
            }
        }
        
        // MARK: - Booking Sheet
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
        
        // MARK: - Trip completed
        .fullScreenCover(isPresented: $showTripCompleted) {
            if let driver = selectedDriver {
                TripCompleted(isPresented: $showTripCompleted, driver: driver)
            } else {
                Text("Noe gikk galt – fant ikke sjåfør")
            }
        }
        
        // MARK: - Booking alert
        .alert("Booking bekreftet", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Du finner bookingen under profilen din.")
        }
        
        // MARK: - Når viewet vises
        .onAppear {
            viewModel.loadDrivers()
            viewModel.placeAllDriversAround(coord: region.center)
        }
        
        // MARK: - Center én gang på brukerposisjon (ingen flere auto-endringer)
        .onChange(of: locationManager.userLocation?.latitude) { _ in
            guard let coord = locationManager.userLocation else { return }
            guard !hasCenteredOnUser else { return }
            
            hasCenteredOnUser = true
            withAnimation { region.center = coord }
        }
    }
    
    private func handleSelectSuggestion(_ suggestion: AutocompleteSuggestion) {
        toText = suggestion.properties.formatted ?? ""
        viewModel.suggestions = []
        
        let coord = suggestion.geometry.coordinate
        
        withAnimation {
            region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
        
        viewModel.placeAllDriversAround(coord: coord)
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(AuthService.shared)
    }
}
