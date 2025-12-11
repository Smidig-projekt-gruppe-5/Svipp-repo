import SwiftUI
// stjerne rating 
struct StarRatingView: View {
    @Binding var rating: Int
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
                        rating = index
                    }
            }
        }
    }
}
