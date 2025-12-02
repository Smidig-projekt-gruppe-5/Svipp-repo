//
//  RatingsView.swift
//  Svipp
//
//  Created by Hannan Moussa on 01/12/2025.
//

import SwiftUI

struct RatingsView: View
{
    var fillPercentage: Double   // mellom 0.0 og 1.0
    
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black.opacity(0.6))  // bakgrunns-stjerne
            
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
                .mask(
                    GeometryReader { geometry in
                        Rectangle()
                            .frame(width: geometry.size.width * fillPercentage)
                    }
                )
                .animation(.easeInOut(duration: 0.3), value: fillPercentage)
        }
    }
}

#Preview
{
    HStack(spacing: 20) {
        RatingsView(fillPercentage: 0.2)
        RatingsView(fillPercentage: 0.5)
        RatingsView(fillPercentage: 1.0)
    }
    .padding()
}
