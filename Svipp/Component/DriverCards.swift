import SwiftUI

struct DriverCard: View {
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Bilde / placeholder
            ZStack {
                if let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("SvippMainColor"))
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("SvippTextColor"))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text(rating)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.orange)
                }
                
                Text(address)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(yearsExperience)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 👉 Pris her
            VStack(alignment: .trailing, spacing: 2) {
                Text("Pris")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                
                Text(price.isEmpty ? "–" : price)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.svippAccent))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    DriverCard(
        name: "Natasha Brun",
        rating: "4.6",
        address: "Oslo sentrum",
        yearsExperience: "3 år som sjåfør – 180 turer",
        price: "663 kr",
        imageName: "Tom"
    )
}
