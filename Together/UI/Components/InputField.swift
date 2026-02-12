//
//  InputField.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

enum InputFieldType {
    case name
    case email
    case password
    case date
}

struct InputField: View {
    let placeholder: String
    let type: InputFieldType
    let viewModel: AuthViewModel
    
    @Binding var text: String
    @Binding var date: Date?
    
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    
    // MARK: - Computed Validation
    private var isValid: Bool {
        switch type {
        case .name:
            viewModel.isNameValid
        case .email:
            viewModel.isEmailValid
        case .password:
            viewModel.isPasswordValid
        case .date:
            true
        }
    }
    
    private var showValidation: Bool {
        switch type {
        case .name:
            !viewModel.name.isEmpty
        case .email:
            !viewModel.email.isEmpty
        case .password:
            !viewModel.password.isEmpty
        case .date:
            false
        }
    }
    
    // MARK: - Initializer
    
    init(
        placeholder: String,
        type: InputFieldType,
        text: Binding<String>,
        date: Binding<Date?> = .constant(nil),
        viewModel: AuthViewModel
    ) {
        self.placeholder = placeholder
        self.type = type
        self._text = text
        self._date = date
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            // MARK: - Field Types
            ZStack(alignment: .trailing) {
                switch type {
                    
                case .date:
                    DatePicker(
                        placeholder,
                        selection: Binding(
                            get: { date ?? Date() },
                            set: { date = $0 }
                        ),
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .fieldStyle(isFocused: isFocused)
                    
                case .password:
                    Group {
                        if showPassword {
                            TextField(placeholder, text: $text)
                        } else {
                            SecureField(placeholder, text: $text)
                        }
                    }
                    .fieldStyle(isFocused: isFocused)
                    .focused($isFocused)
                    
                case .name, .email:
                    TextField(placeholder, text: $text)
                        .fieldStyle(isFocused: isFocused)
                        .textContentType(type == .email ? .emailAddress : .name)
                        .keyboardType(type == .email ? .emailAddress : .default)
                        .textInputAutocapitalization(type == .email ? .never : .words)
                        .focused($isFocused)
                }
                
                // MARK: Trailing Icons
                if type == .password {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.accentColor)
                            .padding(.trailing, 12)
                    }
                } else if (type == .name || type == .email), showValidation {
                    Image(systemName:"checkmark")
                        .foregroundColor(isValid ? .accent : .clear)
                        .padding(.trailing, 12)
                        .animation(.easeInOut(duration: 0.2), value: isValid)
                }
            }
            
            // MARK: - Password Extras
            if type == .password {
                
                HStack {
                    Spacer()
                    NavigationLink("Forgot your password?") {
                        ForgotPasswordView()
                    }
                    .font(.footnote)
                    .foregroundColor(.accent)
                    .fontWeight(.semibold)
                }
                .padding(.top, 4)
            }
            // Password Requirements
            if type == .password && showValidation && !isValid {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Must contain at least:")
                        .font(.system(size: 14))
                        .foregroundColor(.primary.opacity(0.7))
                    
                    PasswordRequirementRow(
                        text: "At least 1 uppercase",
                        isMet: viewModel.hasUppercase
                    )
                    
                    PasswordRequirementRow(
                        text: "At least 1 number",
                        isMet: viewModel.hasNumber
                    )
                    
                    PasswordRequirementRow(
                        text: "At least 8 characters",
                        isMet: viewModel.hasMinLength
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Password Requirement Row

struct PasswordRequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(isMet ? .green : .gray.opacity(0.4))
                .font(.system(size: 16))
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary.opacity(0.8))
        }
    }
}

// MARK: - Form Styling

extension View {
    func fieldStyle(isFocused: Bool) -> some View {
        self
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .font(.system(size: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.accentColor : Color.gray.opacity(0.4),
                        lineWidth: 1.5
                    )
            )
    }
}

// MARK: - Preview

#Preview("All Fields - Sign Up Form") {
    @Previewable @State var mockViewModel = AuthViewModel()
    
    VStack(spacing: 20) {
        InputField(
            placeholder: "Name",
            type: .name,
            text: $mockViewModel.name,
            viewModel: mockViewModel
        )
        
        InputField(
            placeholder: "Email",
            type: .email,
            text: $mockViewModel.email,
            viewModel: mockViewModel
        )
        
        InputField(
            placeholder: "Password",
            type: .password,
            text: $mockViewModel.password,
            viewModel: mockViewModel
        )
    }
    .padding()
}

