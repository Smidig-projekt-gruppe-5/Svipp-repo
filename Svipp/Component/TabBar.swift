import SwiftUI
// tab bar komponent
enum TabSelection {
    case explore
    case profile
}

struct TabBar: View {
    @Binding var selectedTab: TabSelection
    
    var body: some View {
        HStack(spacing: 0) {
            
            Button {
                selectedTab = .explore
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            Rectangle()
                .frame(width: 1, height: 32)
                .foregroundColor(.white.opacity(0.04))
            
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding(.vertical, 12)
        .background(Color.svippMain)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
