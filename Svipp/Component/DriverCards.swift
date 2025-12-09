import SwiftUI

struct DriverCard: View {
    let name: String
    let rating: String
    let address: String
    let yearsExperience: String
    let price: String
    let imageName: String
    var showPriceLabel: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("SvippTextColor"))

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 13))
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

            VStack(alignment: .trailing, spacing: 2) {
                if showPriceLabel {
                    Text("Nok")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text(price)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding()
        .background(Color(red: 0.98, green: 0.96, blue: 0.90))
        .cornerRadius(18)
        .shadow(radius: 2, y: 1)
    }
}
