import SwiftUI

struct ExploreSearch: View {
    @Binding var fromText: String
    @Binding var toText: String
    
    var onSearch: () -> Void
    var onBooking: () -> Void
    
    var suggestions: [AutocompleteSuggestion] = []
    var onSelectSuggestion: ((AutocompleteSuggestion) -> Void)? = nil
    
    // 🔥 NY CALLBACK
    var onClearSuggestions: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            searchCard
            timeRow
        }
        // 🔥 Når man trykker på søkefeltområdet → skjul forslag
        .onTapGesture {
            withAnimation {
                onClearSuggestions?()
            }
        }
    }
    
    
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
                    onClearSuggestions?()   // 🔥 Skjul forslag når søk trykkes
                    onSearch()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 26, weight: .medium))
                }
                .foregroundColor(Color.svippMain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            
            if !suggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(suggestions) { suggestion in
                        Button {
                            withAnimation {
                                onSelectSuggestion?(suggestion)
                                onClearSuggestions?()   // 🔥 Skjul etter valg
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.svippMain)
                                    .font(.system(size: 16))
                                
                                Text(suggestion.properties.formatted ?? "Ukjent adresse")
                                    .foregroundColor(.primary)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                        }
                        Divider().padding(.leading, 40)
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.12), radius: 6)
                .padding(.horizontal, 4)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
    }
    
    
    private var timeRow: some View {
        HStack(spacing: 12) {
            Button(action: onBooking) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.svippAccent)
                        .frame(width: 22, height: 22)
                    
                    Text("Booking")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.svippAccent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.svippMain)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    ExploreSearch(
        fromText: .constant("Min posisjon"),
        toText: .constant("Kalfarlien 21"),
        onSearch: {},
        onBooking: {},
        suggestions: [],
        onSelectSuggestion: nil,
        onClearSuggestions: nil
    )
}
