//
//  DriverCards.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI

    struct DriverCard: View {
        var name: String
        var rating: String
        var address: String
        var yearsExperience: String
        var price: String
        var imageName: String
        
        var body: some View {
            SvippCard {
                HStack(spacing: 16) {
                    
                    // Bilde
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    // Tekst
                    VStack(alignment: .leading, spacing: 6) {
                        
                        // Navn + rating på samme linje
                        HStack(alignment: .firstTextBaseline) {
                            Text(name)
                                .font(.system(size: 19, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Spacer(minLength: 12)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.8))
                            
                            Text(rating)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        Text(address)
                            .font(.system(size: 15))
                            .foregroundColor(.black.opacity(0.75))
                        
                        Text(yearsExperience)
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    // Pris
                    Text(price)
                        .font(.system(size: 22, weight: .bold))
                }
                .padding(.vertical, 8)
            }
        }
    }

#Preview {
    DriverCard(
        name: "Tom Nguyen",
        rating: "4.8",
        address: "Oslo, gamlebyen 54",
        yearsExperience: "2.år som sjåfør - 235 turer",
        price: "555kr",
        imageName: "Tom"
    )
    .padding()
    .background(Color.white)
}
