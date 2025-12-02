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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
