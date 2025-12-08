//
//  RootTabView.swift
//  Svipp
//
//  Created by Kasper Espenes on 02/12/2025.
//

import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: TabSelection = .explore
    var body: some View {
        VStack(spacing: 0) {
            
            Group {
                switch selectedTab {
                case .explore:
                    ExploreView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //TabBar nederst
            TabBar(selectedTab: $selectedTab)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .background(Color.white)
    }
}

#Preview {
    RootTabView()
}
