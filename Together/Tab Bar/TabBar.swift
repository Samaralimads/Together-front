//
//  TabBar.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/02/2026.
//

import SwiftUI

struct TabBar: View {

    private enum AppTab {
        case dashboard, discover, myDates, profile
    }

    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "house", value: .dashboard) {
                DashboardView()
            }

            Tab(value: .discover) {
                ActivityView()
            } label: {
                Label(
                    "Discover",
                    systemImage: selectedTab == .discover ? "sparkle.magnifyingglass" : "magnifyingglass"
                )
            }

            Tab("My Dates", systemImage: "heart", value: .myDates) {
                MyDatesView()
            }

            Tab("Profile", systemImage: "person", value: .profile) {
                ProfileView()
            }
        }
    }
}

#Preview {
    TabBar()
}
