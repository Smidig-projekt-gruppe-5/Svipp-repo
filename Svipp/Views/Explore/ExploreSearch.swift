import SwiftUI

struct ExploreSearch: View {
    @Binding var fromText: String
    @Binding var toText: String
    
    var onSearch: () -> Void
    var onBooking: () -> Void
    
    var suggestions: [AutocompleteSuggestion] = []
    var onSelectSuggestion: ((AutocompleteSuggestion) -> Void)? = nil
    var onClearSuggestions: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            searchCard
            actionRow
        }
        .onTapGesture {
            onClearSuggestions?()
        }
    }
    
    private var searchCard: some View {
        VStack(spacing: 0) {
            
            // Fra:
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
            
            // Til:
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Til:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Skriv adresse…", text: $toText)
                        .textFieldStyle(.plain)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            
            
            // Autocomplete
            if !suggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(suggestions) { suggestion in
                        Button {
                            onSelectSuggestion?(suggestion)
                            onClearSuggestions?()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.svippMain)
                                
                                Text(suggestion.properties.formatted ?? "Ukjent adresse")
                                    .foregroundColor(.primary)
                                    .font(.subheadline)
                                
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
    
    // Store knapper (booking & søk)
    private var actionRow: some View {
        HStack(spacing: 12) {
            
            // Booking
            Button(action: onBooking) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Forhåndsbestill")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.svippMain)
                .cornerRadius(12)
            }
            
            // Søk
            Button(action: onSearch) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Søk")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.svippMain)
                .cornerRadius(12)
            }
        }
    }
}
