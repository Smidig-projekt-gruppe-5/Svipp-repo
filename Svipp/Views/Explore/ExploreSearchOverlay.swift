import SwiftUI

struct ExploreSearchOverlay: View {
    @Binding var fromText: String
    @Binding var toText: String

    var onSearch: () -> Void
    var onBooking: () -> Void
    var onFilter: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            searchCard
            timeRow
        }
    }

    // MARK: - Søke-kortet

    private var searchCard: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Fra:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(fromText)
                        .font(.body)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 8)

            Divider()

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Til:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Skriv adresse…", text: $toText)
                        .textFieldStyle(.plain)
                }

                Spacer()

                Button {
                    onSearch()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                }
                .foregroundColor(Color(.systemTeal))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
    }

    // MARK: - Booking + filter

    private var timeRow: some View {
        HStack(spacing: 12) {
            Button {
                onBooking()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                    Text("Booking")
                }
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(Color(red: 0.47, green: 0.70, blue: 0.72)) // teal-ish
                )
                .foregroundColor(.white)
            }

            Button {
                onFilter()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
            }
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    ExploreSearchOverlay(
        fromText: .constant("Min posisjon"),
        toText: .constant("Kalfarlien 21, Bergen"),
        onSearch: {},
        onBooking: {},
        onFilter: {}
    )
    .padding()
}
