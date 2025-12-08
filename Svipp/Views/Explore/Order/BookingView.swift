import SwiftUI

struct BookingView: View {
    let fromAddress: String      // initial verdi
    let toAddress: String        // initial verdi
    
    @Binding var bookingDate: Date
    
    /// Nå sender vi tilbake de faktiske verdiene brukeren skrev inn
    var onConfirm: (_ from: String, _ to: String, _ info: String) -> Void

    @Environment(\.dismiss) private var dismiss
    
    @State private var fromInput: String = ""
    @State private var toInput: String = ""
    @State private var infoInput: String = ""
    
    private var canConfirm: Bool {
        !fromInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !toInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Adresser
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Hvor skal vi hente og levere?")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Fra-adresse")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    TextField("F.eks. Kalfarlien 21, Bergen", text: $fromInput)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Til-adresse")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    TextField("F.eks. Strandgaten 10, Bergen", text: $toInput)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                if !canConfirm {
                                    Text("Du må fylle inn både fra- og til-adresse.")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                            
                            // Tilleggsinfo
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tilleggsinfo (valgfritt)")
                                    .font(.headline)
                                
                                TextField(
                                    "F.eks. biltype, registreringsnummer, portkode, hvor nøkkel ligger …",
                                    text: $infoInput,
                                    axis: .vertical
                                )
                                .lineLimit(3...5)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                )
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))

                            // Velg tidspunkt
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Når skal vi hente deg?")
                                    .font(.headline)
                                
                                DatePicker(
                                    "Tidspunkt",
                                    selection: $bookingDate,
                                    in: Date()...,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.graphical)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                            
                            Spacer(minLength: 40)
                        }
                        .padding()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        onConfirm(fromInput, toInput, infoInput)
                    } label: {
                        Text("Bekreft booking")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(canConfirm ? Color.svippMain : Color.svippMain.opacity(0.5))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .disabled(!canConfirm)
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Lukk") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if fromInput.isEmpty {
                    fromInput = fromAddress
                }
                if toInput.isEmpty {
                    toInput = toAddress
                }
            }
        }
    }
}

#Preview {
    BookingView(
        fromAddress: "Min posisjon",
        toAddress: "Kalfarlien 21, Bergen",
        bookingDate: .constant(Date()),
        onConfirm: { _, _, _ in }
    )
}
