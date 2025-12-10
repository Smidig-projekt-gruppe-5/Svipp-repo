//
//  TabBar.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI

enum TabSelection {
    case explore
    case profile
}

struct TabBar: View {
    @Binding var selectedTab: TabSelection
    
    var body: some View {
        HStack(spacing: 0) {
            
            Button {
                selectedTab = .explore
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            Rectangle()
                .frame(width: 1, height: 32)
                .foregroundColor(.white.opacity(0.04))
            
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
        }
        .padding(.vertical, 12)
        .background(Color.svippMain)
        //.background(Color(red: 0.05, green: 0.74, blue: 0.74))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    TabBar(selectedTab: .constant(.explore))
        .padding()
}

