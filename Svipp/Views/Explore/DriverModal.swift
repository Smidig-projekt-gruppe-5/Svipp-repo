import SwiftUI

struct DriverModal: View {
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
                    VStack(spacing: 16) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 5)
                            .padding(.top, 8)

                        HStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Ahmed Ali")
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Text("Toyota Prius • SV 39582")
                                    .foregroundColor(.secondary)

                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("4.85")
                                        .bold()
                                }
                            }

                            Spacer()
                        }
                        .padding(.horizontal)

                        Divider()

                        Button {
                            print("Bestill sjåfør")
                        } label: {
                            Text("Bestill sjåfør")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.45) // litt under halv skjerm
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

#Preview {
    DriverModal(isPresented: .constant(true))
}
