import SwiftUI

struct TripCompleted: View {
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Takk for at du brukte vår tjeneste! ")
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
            
            // ⭐️ Stjerner
            StarRatingView(rating: $rating)
                .frame(height: 24)
                .padding(.top, 4)
            
            if rating > 0 {
                PrimaryButton(text: "Send inn") {
                    withAnimation {
                        print("Rating sendt: \(rating)")
                        isPresented = false
                    }
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
}

#Preview {
    TripCompletedPreview()
}

struct TripCompletedPreview: View {
    @State private var isPresented: Bool = true
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            
            TripCompleted(isPresented: $isPresented)
        }
    }
}
