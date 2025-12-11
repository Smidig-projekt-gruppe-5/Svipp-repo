import SwiftUI

struct DriverSummaryCard: View {
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
    var showPriceLabel: Bool = true
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Sjåførbilde
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                
                // Navn + rating
                HStack {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer(minLength: 8)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text(rating)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                }
                
                Text(address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(yearsExperience)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Pris (med valgfritt "Pris"-label)
            VStack(alignment: .trailing, spacing: 2) {
                if showPriceLabel {
                    Text("Nok")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(price)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .padding(.top, 20)
        .background(Color(.systemBackground))
    }
}
