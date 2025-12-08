import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int        // Binding i stedet for vanlig var
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundColor(
                        index <= rating
                        ? .yellow
                        : Color("SvippTextColor").opacity(0.8)
                    )
                    .onTapGesture {
                        rating = index   // Oppdater rating når man trykker
                    }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StatefulStarRatingPreview()
            .frame(height: 20)
    }
    .padding()
}

struct StatefulStarRatingPreview: View {
    @State private var rating: Int = 1
    
    var body: some View {
        StarRatingView(rating: $rating)
    }
}
