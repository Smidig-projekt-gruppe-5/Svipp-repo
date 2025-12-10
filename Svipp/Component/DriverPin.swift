import SwiftUI

struct DriverPin: View {
    let imageName: String
    let priceText: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())

                Text(formatPrice(priceText))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .background(
            Capsule()
                .fill(Color(.white))
        )
        .shadow(radius: 1)
    }

    private func formatPrice(_ text: String) -> String {
        let digits = text.filter { "0123456789".contains($0) }
        return "NOK \(digits)"
    }
}

#Preview {
    DriverPin(imageName: "Tom", priceText: "555 kr") { }
        .padding()
}
