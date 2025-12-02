import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
