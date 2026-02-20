//
//  TabBar.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/02/2026.
//

import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                        .environment(
                            \.symbolVariants,
                             selectedTab == 0 ? .fill : .none
                        )
                }
                .tag(0)
            
            ActivityView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "sparkle.magnifyingglass" : "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            MyDatesView()
                .tabItem {
                    Label("My Dates", systemImage: "heart")
                        .environment(
                            \.symbolVariants,
                             selectedTab == 2 ? .fill : .none
                        )
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .environment(
                            \.symbolVariants,
                             selectedTab == 3 ? .fill : .none
                        )
                }
                .tag(3)
        }
    }
}


#Preview {
    TabBar()
}
