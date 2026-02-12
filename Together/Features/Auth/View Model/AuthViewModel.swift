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
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    //MARK: - Password validation
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
    
    //MARK: - Email validation
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    //MARK: - Name validation
    var isNameValid: Bool {
        name.count >= 2
    }
    
    //MARK: - Validation for Sign Up/In
    var canSignUp: Bool {
        isNameValid && isEmailValid && isPasswordValid && !isLoading
    }
    
    var canSignIn: Bool {
        isEmailValid && !password.isEmpty && !isLoading
    }
    
    //MARK: - SignIn
    func signIn() async {
        guard canSignIn else { return }
        isLoading = true
        errorMessage = nil
        
        // TODO: Call AuthService
        
        isLoading = false
    }
    
    //MARK: - Signup
    func signUp() async {
        guard canSignUp else { return }
        isLoading = true
        errorMessage = nil
        
        // TODO: Call AuthService
        
        isLoading = false
    }
}
