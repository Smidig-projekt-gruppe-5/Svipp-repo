import SwiftUI
// default modal 
struct Modal<Content: View>: View {
    @Binding var isPresented: Bool
    var title: String?
    var heightFraction: CGFloat
    let content: Content
    
    init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        heightFraction: CGFloat = 0.6,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.title = title
        self.heightFraction = heightFraction
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            if isPresented {
                ZStack(alignment: .bottom) {
                    
                    // Mørk bakgrunn
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isPresented = false
                            }
                        }
                    
                    // Selve bottom sheet’en
                    VStack(spacing: 12) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 12)
                        
                        if let title {
                            Text(title)
                                .font(.headline)
                                .padding(.bottom, 4)
                        }
                        
                        content
                    }
                    .frame(height: geometry.size.height * heightFraction)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
                .ignoresSafeArea(edges: .bottom)
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

#Preview {
    Modal(isPresented: .constant(true), title: "Eksempel", heightFraction: 0.9) {
        Text("Innhold her")
            .padding()
    }
}
