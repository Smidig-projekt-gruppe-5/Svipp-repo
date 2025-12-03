import SwiftUI
import MapKit

struct PickUpModal: View {
    @Binding var isPresented: Bool
    let driver: DriverInfo
    let pinCode: String
    @Binding var showTripCompleted: Bool
    @State private var secondsLeft: Int = 30

    
    var onCancel: (() -> Void)? = nil

    @State private var isCalling = false   // kun brukt når du trykker "Ring sjåfør"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    private let etaText = "Estimert ventetid: 5–10 min"

    var body: some View {
        ZStack(alignment: .top) {

            Map(coordinateRegion: $region)
                .ignoresSafeArea()

            VStack(spacing: 16) {

                Spacer().frame(height: 40)

                statusCard

                Spacer()

                pinCard

                driverBottomCard
                    .padding(.bottom, 80)
            }
            .padding(.horizontal, 16)

            // 📞 Calling overlay (kun når du trykker "Ring sjåfør")
            if isCalling {
                callingOverlay
            }
        }
        .onAppear {
            startAutoCompleteTimer()   // 👈 STARTER MED EN GANG MODALEN ÅPNER
        }
        .onAppear {
            startCountdown()
        }

        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 30 SEKUND AUTO TIMER
    private func startAutoCompleteTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            // Lukk denne modal
            isPresented = false
            
            // Vis TripCompleted
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showTripCompleted = true
            }
        }
    }

    // MARK: - Overlay
    private var callingOverlay: some View {
        VStack(spacing: 12) {
            Image(systemName: "phone.fill")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color("SvippMainColor"))
                .symbolEffect(.pulse)

            Text("Ringer \(driver.name)…")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("SvippTextColor"))

            ProgressView()
                .tint(Color("SvippMainColor"))
                .scaleEffect(1.2)
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 36)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8, y: 3)
        .offset(y: 180)
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Status
    private var statusCard: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color("SvippAccent").opacity(0.25))
                    .frame(width: 46, height: 46)

                Image(systemName: "bicycle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color("SvippMainColor"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Sjåføren er på vei…")
                    .font(.headline)

                Text("Estimert tid: \(secondsLeft) sekunder")
                    .font(.subheadline)
                    .foregroundColor(Color("SvippMainColor"))
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4, y: 2)
    }

    // MARK: - PIN
    private var pinCard: some View {
        VStack(spacing: 10) {
            Text("Din PIN-kode:")
                .foregroundColor(.secondary)

            Text(pinCode)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .kerning(6)
                .foregroundColor(Color("SvippTextColor"))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4, y: 2)
    }
    private func startCountdown() {
        // Oppdater hvert sekund
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in

            if secondsLeft > 0 {
                secondsLeft -= 1
            }

            // Ferdig → gå til TripCompleted
            if secondsLeft == 0 {
                timer.invalidate()

                withAnimation {
                    isPresented = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showTripCompleted = true
                }
            }
        }
    }


    // MARK: - DRIVER INFO/BUTTONS
    private var driverBottomCard: some View {
        VStack(spacing: 12) {

            HStack(spacing: 12) {
                Image(driver.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(driver.name).font(.headline)
                    Text(driver.yearsExperience)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack {
                    Image(systemName: "star.fill")
                    Text(driver.rating)
                }
                .foregroundColor(.black.opacity(0.85))
            }

            HStack(spacing: 12) {

                // 📞 Ring sjåfør (kun overlay)
                Button {
                    withAnimation { isCalling = true }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation { isCalling = false }
                    }

                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "phone")
                        Text("Ring sjåfør")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .foregroundColor(Color("SvippMainColor"))
                    .background(Capsule().stroke(Color("SvippMainColor"), lineWidth: 1.5))
                }

                Spacer()

                // ❌ Avbryt
                Button {
                    onCancel?()
                    withAnimation { isPresented = false }
                } label: {
                    Text("Avbryt turen")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 18)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.red.opacity(0.85)))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4, y: 2)
    }
}
