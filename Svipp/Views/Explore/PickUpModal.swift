import SwiftUI
import MapKit

struct PickUpModal: View {
    @Binding var isPresented: Bool
    let driver: DriverInfo
    let pinCode: String
    var onCancel: (() -> Void)? = nil

    @State private var isCalling = false
    @State private var showTripCompleted = false   // 👈 Navigerer videre her

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

            // 📞 Calling overlay
            if isCalling {
                callingOverlay
            }

            // ⭐ Navigasjon til TripCompleted (ny skjerm)
            NavigationLink(
                destination: TripCompletedView(driver: driver),
                isActive: $showTripCompleted
            ) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
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
                .padding(.top, 4)

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

                Text(etaText)
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
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(pinCode)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .kerning(6)
                .foregroundColor(Color("SvippTextColor"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4, y: 2)
    }

    // MARK: - Bottom driver card
    private var driverBottomCard: some View {
        VStack(spacing: 12) {

            HStack(spacing: 12) {
                Image(driver.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(driver.name)
                        .font(.system(size: 18, weight: .semibold))

                    Text(driver.yearsExperience)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                    Text(driver.rating)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.black.opacity(0.85))
            }

            HStack(spacing: 12) {

                // 📞 RING SJÅFØR
                Button {
                    simulateCalling()  // 👈 30 sek + navigasjon
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "phone")
                        Text("Ring sjåfør")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .foregroundColor(Color("SvippMainColor"))
                    .background(
                        Capsule()
                            .stroke(Color("SvippMainColor"), lineWidth: 1.5)
                    )
                }

                Spacer()

                // ❌ Avbryt tur
                Button {
                    onCancel?()
                    withAnimation { isPresented = false }
                } label: {
                    Text("Avbryt turen")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 18)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.85))
                        )
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(radius: 4, y: 2)
    }

    // MARK: - 30 SEKUND SIMULERT ANROP
    private func simulateCalling() {
        withAnimation(.easeInOut) {
            isCalling = true
        }

        // ⏳ 30 SECONDS
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {

            withAnimation(.easeInOut) {
                isCalling = false
            }

            // 👉 Naviger til TripCompleted
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showTripCompleted = true
            }
        }
    }
}
