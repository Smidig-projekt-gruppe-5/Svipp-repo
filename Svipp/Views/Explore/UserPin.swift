import SwiftUI

struct UserPin: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.svippAccent)
                .frame(width: 36, height: 36)
                .shadow(radius: 3)

            Image(systemName: "person.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.svippMain)
        }
    }
}
#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        UserPin()
    }
}
