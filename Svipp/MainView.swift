import SwiftUI

struct MainView: View {
    @State private var selectedTab: TabSelection = .explore
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
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
            
            TabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


