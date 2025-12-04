import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import UIKit

// MARK: - Firebase AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SvippApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()                     // 👈 VIKTIG: IKKE MainView her
                .environmentObject(authService)
        }
    }
}
