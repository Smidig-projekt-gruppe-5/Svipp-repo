import SwiftUI

struct DriverCard: View {
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
    var showPriceLabel: Bool = true
    let onTapDetails: () -> Void
    var showDetailsButton: Bool = true
    var rightPaddingForPrice: CGFloat = 0
    
    var showsHeart: Bool = false
    var isFavorite: Bool = false
    var onToggleFavorite: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 14) {
            // Bilde
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            
            // VENSTRE: navn, rating, adresse, erfaring
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text(rating)
                            .font(.system(size: 13, weight: .semibold))
                    }
                }
                
                Text(address)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(yearsExperience)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // HØYRE: NOK + pris + (valgfritt) hjerte
            VStack(alignment: .trailing, spacing: 4) {
                
                
                if showsHeart, let onToggleFavorite {
                    Button {
                        onToggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom,10)
                }
                HStack(spacing: 8) {
                    if showPriceLabel {
                        Text("NOK")
                            .font(.caption)
                    }
                    
                    Text(price)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.trailing, rightPaddingForPrice)
                    
                    if showDetailsButton {
                        Button(action: onTapDetails) {
                            Text("Vis profil")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("SvippTextColor"))
                        }
                    }
                }
            }
            .padding(12)
            .background(Color(red: 0.98, green: 0.96, blue: 0.90))
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.07), radius: 3, y: 1)
        }
    }
}
