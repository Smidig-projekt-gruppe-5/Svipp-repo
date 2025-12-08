
import Foundation
import SwiftUI

// MARK: - Sorteringsmoduser for sjåfører

enum DriverSortMode: String, CaseIterable {
    case distance = "Nærmeste til lengst unna"
    case rating   = "Høyest rating"
    case price    = "Pris lav–høy"
    
    var icon: String {
        switch self {
        case .distance: return "location.north.line"
        case .rating:   return "star.fill"
        case .price:    return "creditcard"
        }
    }
}

// MARK: - Filter / sorteringslogikk for DriverInfo

struct DriverFilter {
    
    static func sort(drivers: [DriverInfo], by mode: DriverSortMode) -> [DriverInfo] {
        switch mode {
        case .distance:
            // Foreløpig: behold original rekkefølge (default).
            // Her kan du senere sortere basert på faktisk distanse.
            return drivers
            
        case .rating:
            return drivers.sorted {
                parseRating($0.rating) > parseRating($1.rating)
            }
            
        case .price:
            return drivers.sorted {
                parsePrice($0.price) < parsePrice($1.price)
            }
        }
    }
    
    // "4.8" -> 4.8
    private static func parseRating(_ text: String) -> Double {
        // Hvis du noen gang får komma, f.eks "4,8"
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0
    }
    
    // "555 kr" -> 555
    private static func parsePrice(_ text: String) -> Int {
        let digits = text.filter { $0.isNumber }
        return Int(digits) ?? Int.max
    }
}

// MARK: - Filter meny-komponent som kan festes på knappen

struct DriverFilterMenu: View {
    @Binding var selectedMode: DriverSortMode
    
    var body: some View {
        Menu {
            Text("Sorter etter")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ForEach(DriverSortMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut) {
                        selectedMode = mode
                    }
                } label: {
                    Label(mode.rawValue, systemImage: mode.icon)
                    
                    if mode == selectedMode {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                Text(selectedMode.rawValue)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .padding(10)
            .foregroundColor(Color.svippText)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}
