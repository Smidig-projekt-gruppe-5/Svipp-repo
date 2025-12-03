import SwiftUI

struct BackButtonOverlay: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("SvippAccent"))
                .padding(10)
                .background(Color("SvippMainColor"))
                .clipShape(Circle())
                .shadow(radius: 3, y: 1)
        }
        .padding(.leading, 20)
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .allowsHitTesting(true)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
        BackButtonOverlay {
            print("Tilbake")
        }
    }
}
