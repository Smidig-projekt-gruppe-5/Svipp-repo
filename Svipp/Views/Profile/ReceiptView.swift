import SwiftUI

enum ReceiptFeedback: Identifiable {
    case pdf
    case email
    
    var id: Int {
        switch self {
        case .pdf: return 0
        case .email: return 1
        }
    }
}

struct ReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    
    private var userName: String {
        authService.currentUserProfile?.name ?? "kunde"
    }
    
    let total: String
    let paymentMethod: String
    let dateString: String
    
    @State private var feedbackType: ReceiptFeedback? = nil

    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.96, blue: 0.90).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("KVITTERING")
                        .font(.system(size: 18, weight: .semibold))
                        .tracking(2)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(red: 0.98, green: 0.96, blue: 0.90))
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // boks 1 (Svipp + takk)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SVIPP")
                                .font(.system(size: 13, weight: .semibold))
                            
                            Text(dateString)
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.5))
                            
                            Text("TAKK FOR AT DU BRUKTE SVIPP, \(userName.uppercased())!")
                                .font(.system(size: 18, weight: .bold))
                            
                            Text("VI HÅPER DU FIKK EN GOD TUR OG HÅPER Å SE DEG IGJEN!")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.90, green: 0.88, blue: 0.84))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .padding(.top, 24)
                        
                        // Boks 2 (Total / Betaling)
                        VStack(spacing: 5) {
                            receiptRow(label: "TOTAL", value: total)
                            Divider()
                            receiptRow(label: "BETALING", value: paymentMethod)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.98, green: 0.96, blue: 0.90))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        // PDF & e-post
                        VStack(spacing: 24) {
                            receiptActionButton(
                                systemImage: "arrow.down.circle",
                                title: "Last ned som PDF"
                            ) {
                                feedbackType = .pdf
                            }
                            
                            receiptActionButton(
                                systemImage: "envelope",
                                title: "Send til e-post"
                            ) {
                                feedbackType = .email
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 32)
                    }
                }
            }
        }
        // 👇 Alert på selve viewet, ikke på ScrollView
        .alert(item: $feedbackType) { type in
            switch type {
            case .pdf:
                return Alert(
                    title: Text("PDF lastet ned"),
                    message: Text("Kvitteringen er lastet ned som PDF."),
                    dismissButton: .default(Text("OK"))
                )
            case .email:
                return Alert(
                    title: Text("E-post sendt"),
                    message: Text("Kvitteringen er sendt til e-postadressen din."),
                    dismissButton: .default(Text("Supert!"))
                )
            }
        }
    }
}

#Preview {
    ReceiptView(
        total: "NOK 459",
        paymentMethod: "Visa *1234",
        dateString: "NOV 26, 2025, 11:02 AM"
    )
    .environmentObject(AuthService.shared)
}
