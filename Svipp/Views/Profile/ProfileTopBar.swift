import SwiftUI

struct ProfileTopBar: View {
    let onFavoritesTapped: () -> Void

    var body: some View {
        HStack {
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(Color("SvippTextColor"))
                    .padding(.leading, 12)
                    .padding(.vertical, 8)
            }

            Spacer()

            PrimaryButton(text: "Favoritter") {
                onFavoritesTapped()
            }
            .padding(.trailing, 12)
            .padding(.vertical, 8)
        }
        .padding(.top, 6)
    }
}
