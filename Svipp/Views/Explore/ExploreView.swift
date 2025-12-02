import SwiftUI

struct ExploreView: View {
    @State private var fromText: String = "Min posisjon"
    @State private var toText: String = ""
    @State private var showDriverModal = false

    var body: some View {
        ZStack(alignment: .top) {
            // Bakgrunn (kart senere)
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ExploreSearchOverlay(
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
                        showDriverModal = true
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

            DriverModal(isPresented: $showDriverModal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Explore")
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
