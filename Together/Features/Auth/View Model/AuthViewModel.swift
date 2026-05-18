//
//  AuthViewModel.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import Foundation

@Observable
class AuthViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var birthDate: Date? = nil
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isAuthenticated: Bool = false

    // MARK: - Password validation
    var hasUppercase: Bool {
        password.range(of: "[A-Z]", options: .regularExpression) != nil
    }
    
    var hasNumber: Bool {
        password.range(of: "[0-9]", options: .regularExpression) != nil
    }
    
    var hasMinLength: Bool {
        password.count >= 8
    }
    
    var isPasswordValid: Bool {
        hasUppercase && hasNumber && hasMinLength
    }
    
    // MARK: - Email validation
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // MARK: - Name validation
    var isNameValid: Bool {
        name.count >= 2
    }

    // MARK: - Birth date validation
    var isBirthDateValid: Bool {
        birthDate != nil
    }

    var canSignUp: Bool {
        isNameValid && isEmailValid && isPasswordValid && isBirthDateValid && !isLoading
    }

    var canSignIn: Bool {
        isEmailValid && !password.isEmpty && !isLoading
    }

    // MARK: - Sign Up
    func signUp() async {
        guard canSignUp, let birthDate else { return }
        isLoading = true
        errorMessage = nil

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let birthDateString = formatter.string(from: birthDate)

        do {
            _ = try await AuthService.register(
                firstName: name,
                birthDate: birthDateString,
                email: email,
                password: password
            )
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Sign In
    func signIn() async {
        guard canSignIn else { return }
        isLoading = true
        errorMessage = nil

        do {
            _ = try await AuthService.login(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Logout
    func logout() {
        AuthService.logout()
        isAuthenticated = false
    }
}
