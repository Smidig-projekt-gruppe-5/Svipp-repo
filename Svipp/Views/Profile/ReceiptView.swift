//
//  Receipt.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

// Dytte Last ned som PDF og send til e-post lengre ned??

import SwiftUI

struct ReceiptView: View {
    
    //Disse kan vi endre senere når vi får ekte data
    var name: String = "Mathias"
    var total: String = "NOK 459"
    var paymentMethod: String = "Visa *1234"
    var dateString: String = "NOV 26, 2025, 11:02 AM"
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.96, blue: 0.90).ignoresSafeArea()
            // Top bar
            VStack(spacing: 0) {
                HStack {
                    Button {
                        // Gå tilbake
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
                            
                            Text("TAKK FOR AT DU BRUKTE SVIPP, \(name.uppercased())!")
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
                            )
                            
                            receiptActionButton(
                                systemImage: "envelope",
                                title: "Send til e-post"
                            )
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 32)
                    }
                }
            }
        }
    }
}

#Preview {
    ReceiptView()
}
