import SwiftUI

struct ProfileBookingsSection: View {
    let bookings: [SvippBooking]
    let onDelete: (SvippBooking) -> Void
    
    var body: some View {
        let upcoming = upcomingBookings()
        
        return Group {
            if upcoming.isEmpty {
                EmptyView()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Mine bookinger")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ForEach(upcoming, id: \.id) { booking in
                        ProfileBookingRow(
                            booking: booking,
                            onDelete: onDelete
                        )
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    // Enkel, tydelig funksjon – mindre jobb for kompileren
    private func upcomingBookings() -> [SvippBooking] {
        let now = Date()
        
        let filtered = bookings.filter { booking in
            booking.pickupTime >= now
        }
        
        let sorted = filtered.sorted { a, b in
            a.pickupTime < b.pickupTime
        }
        
        return sorted
    }
}

// Egen rad for hver booking – gjør body mye enklere
private struct ProfileBookingRow: View {
    let booking: SvippBooking
    let onDelete: (SvippBooking) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate(booking.pickupTime))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("\(booking.fromAddress) → \(booking.toAddress)")
                        .font(.subheadline)
                    
                    if let note = booking.note,
                       !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(note)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    onDelete(booking)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
    }
}

// Felles formatter
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "nb_NO")
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
