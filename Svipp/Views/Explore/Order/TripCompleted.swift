import SwiftUI

struct TripCompleted: View {
    @Binding var isPresented: Bool
    let driver: DriverInfo
    
    @EnvironmentObject var authService: AuthService
    
    @State private var rating: Int = 0
    @State private var comment: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Takk for at du brukte Svipp!")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("SvippTextColor"))
            }
            
            VStack(spacing: 4) {
                Text("Din mening er viktig!")
                    .font(.title3.bold())
                    .foregroundColor(Color("SvippTextColor"))
                
                Text("Gi sjåføren en vurdering")
                    .font(.headline)
                    .foregroundColor(Color("SvippTextColor").opacity(0.8))
            }
            
            StarRatingView(rating: $rating)
                .frame(height: 24)
                .padding(.top, 4)
            
            TextField("Legg igjen en kommentar (valgfritt)", text: $comment, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3, reservesSpace: true)
                .padding(.horizontal)
            
            if rating > 0 {
                PrimaryButton(text: "Send inn") {
                    sendReview()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            } else {
                SecondaryButton(text: "Kanskje senere") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            }
        }
        .padding()
    }
    
    private func sendReview() {
        authService.addReview(for: driver, rating: rating, comment: comment.isEmpty ? nil : comment) { _ in
            withAnimation {
                isPresented = false
            }
        }
    }
}
