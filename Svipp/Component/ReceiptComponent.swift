import SwiftUI
// denne brukes til kvittering (Tidligere bestilling side)
struct receiptRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.8))
        }
        .padding(.vertical, 8)
    }
}

// kvittering knapp 
struct receiptActionButton: View {
    let systemImage: String
    let title: String
    let action: () -> Void      

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.98, green: 0.96, blue: 0.90))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
