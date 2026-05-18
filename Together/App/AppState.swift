//
//  AppState.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/05/2026.
//

import Foundation

@Observable
class AppState {
    var isAuthenticated: Bool = JWTService.getToken() != nil

    func login() {
        isAuthenticated = true
    }

    func logout() {
        AuthService.logout()
        isAuthenticated = false
    }
}
