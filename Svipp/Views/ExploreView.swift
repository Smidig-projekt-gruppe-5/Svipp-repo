import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Explore")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
