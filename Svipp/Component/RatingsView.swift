//
//  RatingsView.swift
//  Svipp
//
//  Created by Hannan Moussa on 01/12/2025.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Int
 
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Image(systemName: index < rating ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(
                        index < rating
                        ? .yellow
                        : Color("SvippTextColor").opacity(0.8)
                    )
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: 1)
            .frame(height: 20)
    }
    .padding()
}
