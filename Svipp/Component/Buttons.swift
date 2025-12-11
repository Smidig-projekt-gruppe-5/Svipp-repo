import SwiftUI

struct PrimaryButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("SvippAccent"))
                .frame(width: 118, height: 38)

        }
        .background(Color("SvippMainColor"))
        .clipShape(Capsule())
    }
}

struct SecondaryButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("SvippAccent"))
                .frame(maxWidth: .infinity, maxHeight: 40)
        }
        .background(Color("SvippMainColor"))
               .cornerRadius(14)
               .padding(.horizontal, 16)
    }
}

struct TertiaryButton: View {
    
    let text: String
    let iconName: String?
    let action: () -> Void
    
    private let iconSize: CGFloat = 44
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
                
                HStack {
                    if let iconName {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                    }
                    
                    Spacer()
                    
                    if iconName != nil {
                        Color.clear
                            .frame(width: iconSize, height: iconSize)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, minHeight: 40)
        }
        .background(Color(.sRGB,
                          red: 0.933,
                          green: 0.933,
                          blue: 0.933,
                          opacity: 1))
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }
}

struct PriceButton: View {
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
                
                Text(priceText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .background(
            Color("SvippAccent"))
        
        .clipShape(Capsule())
        .shadow(radius: 1)
    }
}


struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {

            PrimaryButton(text: "Primary") { }

            SecondaryButton(text: "Secondary") { }

            TertiaryButton(text: "Tertiary", iconName: "exampleIcon") { }

            PriceButton(imageName: "exampleProfile", priceText: "NOK 129") { }

        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
