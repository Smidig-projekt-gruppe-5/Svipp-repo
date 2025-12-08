
import SwiftUI

struct TripCompleted: View {
    @Binding var isPresented: Bool
    
    
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
                    .foregroundStyle(.secondary)
                    .foregroundColor(Color("SvippTextColor"))
            }
            
            // Stjerner
            
            
            // "Kanskje senere"-knapp
            SecondaryButton(text: "Kanskje senere") {
                withAnimation {
                    isPresented = false
                }
            }
            .frame(maxWidth: .infinity)   // gjør at knappen strekker seg fint
            .padding(.top, 8)
        }
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
