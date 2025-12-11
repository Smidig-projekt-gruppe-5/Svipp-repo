import SwiftUI

struct DriverManagementView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        List {
            if authService.previousDrivers.isEmpty {
                Text("Ingen sjåfører enda")
                    .foregroundColor(.gray)
            } else {
                ForEach(authService.previousDrivers) { driver in
                    NavigationLink {
                        EditDriverView(driver: driver)
                    } label: {
                        HStack {
                            Text(driver.name)
                            Spacer()
                            if !driver.price.isEmpty {
                                Text(driver.price)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Sjåfører")
        .onAppear {
            authService.loadPreviousDrivers()
        }
    }
}
