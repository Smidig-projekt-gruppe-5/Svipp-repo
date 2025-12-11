import Foundation
import SwiftUI

// sortering av sjåfører
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

// filter og sortering logikk for DriverInfo
struct DriverFilter {
    
    static func sort(drivers: [DriverInfo], by mode: DriverSortMode) -> [DriverInfo] {
        switch mode {
        case .distance:

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
    
    private static func parseRating(_ text: String) -> Double {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0
    }
    
    private static func parsePrice(_ text: String) -> Int {
        let digits = text.filter { $0.isNumber }
        return Int(digits) ?? Int.max
    }
}

// filter meny
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
