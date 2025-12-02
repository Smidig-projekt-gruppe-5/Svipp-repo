import SwiftUI
import SwiftData

@main
struct SvippApp: App {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()          // ingen gjennomsiktighet
        appearance.backgroundColor = UIColor.systemBackground  // samme som app-bakgrunn
        // Du kan bruke f.eks. UIColor.systemGray6 for litt lys “kort”-følelse

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }


    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
