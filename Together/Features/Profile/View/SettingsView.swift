//
//  SettingsView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @Environment(AppState.self) private var appState
    @State private var showLogoutAlert = false

    var body: some View {
        Background {
            List {
                Section {
                    NavigationLink("About you") {
                        AboutYouView()
                    }

                    NavigationLink("Your relationship") {
                        AboutRelationshipView()
                    }

                    NavigationLink("Notification Settings") {
                        NotificationView()
                    }

                    Button("Help & Support") {
                        // TODO: send email to support
                    }

                    Button("Leave us a review") {
                        requestReview()
                    }
                }
                .tint(.primary)
                .padding(.vertical, 10)

                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Text("Log out")
                    }
                    .alert("Log Out", isPresented: $showLogoutAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Log out", role: .destructive) {
                            appState.logout()
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                }
                .padding(.vertical, 8)
            }
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.title.weight(.semibold))
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
