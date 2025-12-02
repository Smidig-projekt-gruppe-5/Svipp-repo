//
//  ReceiptComponent.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI
// Denne brukes til kvittering (Tidligere bestilling side)
struct TripAmount: View {
    var amount: String
    var brand: String
    var last4: String
    
    var body: some View {
        SvippCard {
            HStack {
                Text("Beløp : \(amount)")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.black.opacity(0.8))
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(brand)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.00, green: 0.23, blue: 0.54)) // VISA-Farger
                    Text(last4)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    TripAmount(amount: "NOK 192", brand: "VISA", last4: "1933")
        .padding()
        .background(Color.white)
}
