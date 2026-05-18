//
//  TogetherApp.swift
//  Together
//
//  Created by Samara Lima da Silva on 09/02/2026.
//

import SwiftUI

@main
struct TogetherApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                TabBar()
                    .environment(appState)
            } else {
                NavigationStack {
                    WelcomeView()
                }
                .environment(appState)
            }
        }
    }
}
