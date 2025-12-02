import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
