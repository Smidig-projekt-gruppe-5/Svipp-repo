import SwiftUI
import MapKit

struct ExploreView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    @State private var showFilter = false
    
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
            
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                
                ExploreSearch(
                    fromText: $fromText,
                    toText: $toText,
                    onSearch: {
                        //Driverlisten kommer alltid opp
                        withAnimation {
                            showDriverList = true
                        }
                    },
                    onBooking: { showBooking = true },
                    suggestions: viewModel.suggestions,
                    onSelectSuggestion: { suggestion in
                        handleSelect(suggestion)
                    }
                )
                .onChange(of: toText) { newValue in
                    viewModel.query = newValue
                    Task {
                        await viewModel.searchAutocomplete()
                        print("Søker etter: \(newValue)")
                        print("Antall alternativer: \(viewModel.suggestions.count)")
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            MapZoomControls(region: $region, bottomPadding: 100)
                .zIndex(0)
            
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
            .zIndex(1)
            
            if let selectedDriver {
                DriverOrder(
                    isPresented: $showDriverOrder,
                    showDriverList: $showDriverList,
                    showPickUp: $showPickUp,
                    driver: selectedDriver
                )
                .zIndex(2)
            }
            
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
        
        .fullScreenCover(isPresented: $showTripCompleted) {
            TripCompleted(isPresented: $showTripCompleted)
        }
        
        .alert("Booking bekreftet", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Vi har mottatt bookingen din. Du finner den under profilen din.")
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Last inn sjåfører
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
    }
}

#Preview {
    NavigationStack {
        ExploreView()
            .environmentObject(AuthService.shared)
    }
}
