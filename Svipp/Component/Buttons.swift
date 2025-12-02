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
    
    private let iconSize: CGFloat = 24
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Midtstilt tekst
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("SvippTextColor"))
                
                // Ikon venstre + ghost-ikon høyre
                HStack {
                    if let iconName {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                    }
                    
                    Spacer()
                    
                    // Ghost ikon – holder teksten 100% i midten
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
                          opacity: 1)) // #EEEEEE
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }
}




#Preview("Med ikon") {
    TertiaryButton(text: "Logg inn med Vipps",
                   iconName: "Svipp") {
        print("Vipps tapped")
    }
}


#Preview("Uten ikon") {
    TertiaryButton(text: "Lag Bruker",
                   iconName: nil) {
        print("Lag bruker tapped")
    }
}
