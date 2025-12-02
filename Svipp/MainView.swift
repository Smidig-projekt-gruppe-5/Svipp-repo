import SwiftUI

struct MainView: View {
    @State private var selectedTab: TabSelection = .explore
    
    var body: some View {
        ZStack(alignment: .bottom) {

            // MAIN VIEWS
            Group {
                switch selectedTab {
                case .explore:
                    NavigationStack {
                        ExploreView()
                    }
                case .profile:
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)

            // CUSTOM TAB BAR
            VStack {
                TabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    MainView()
}
