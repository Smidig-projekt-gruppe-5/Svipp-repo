import SwiftUI

struct Modal: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if isPresented {
                ZStack(alignment: .bottom) {
                    // Mørk bakgrunn bak modalen
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isPresented = false
                            }
                        }
                    
                    // Selve modalen
                    VStack {
                        Capsule()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 5)
                            .padding(.top, 8)
                        
                        Text("Dette er modalen (fjernes etterpå i comp)")
                            .font(.title3)
                            .padding()
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 3 / 4) // 2/3 av skjermen
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

#Preview {
    Modal(isPresented: .constant(true))
}
