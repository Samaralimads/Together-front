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

struct PasswordRequirements {
    let hasUppercase: Bool
    let hasNumber: Bool
    let hasMinLength: Bool
}

struct InputField: View {
    let placeholder: String
    let type: InputFieldType

    @Binding var text: String
    @Binding var date: Date?

    var isValid: Bool = true
    var passwordRequirements: PasswordRequirements? = nil

    @State private var showPassword = false
    @State private var showPasswordRequirements = false
    @FocusState private var isFocused: Bool

    // MARK: - Initializers

    // For text-based fields
    init(
        placeholder: String,
        type: InputFieldType,
        text: Binding<String>,
        isValid: Bool = true,
        passwordRequirements: PasswordRequirements? = nil
    ) {
        self.placeholder = placeholder
        self.type = type
        self._text = text
        self._date = .constant(nil)
        self.isValid = isValid
        self.passwordRequirements = passwordRequirements
    }

    // For date field
    init(
        placeholder: String,
        type: InputFieldType = .date,
        date: Binding<Date?>,
        isValid: Bool = true
    ) {
        self.placeholder = placeholder
        self.type = type
        self._text = .constant("")
        self._date = date
        self.isValid = isValid
        self.passwordRequirements = nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // MARK: - Field Types
            ZStack(alignment: .trailing) {
                switch type {

                case .date:
                    DatePicker(
                        placeholder,
                        selection: Binding(
                            get: { date ?? Date.now },
                            set: { date = $0 }
                        ),
                        in: ...Date.now,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .fieldStyle(isFocused: true)

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

                // MARK: - Trailing Icons
                if type == .password {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .contentTransition(.symbolEffect(.replace))
                            .foregroundStyle(Color.accentColor)
                            .padding(.trailing, 12)
                    }
                } else if (type == .name || type == .email), !text.isEmpty {
                    Image(systemName: "checkmark")
                        .foregroundStyle(isValid ? Color.accentColor : Color.clear)
                        .padding(.trailing, 12)
                        .symbolEffect(.bounce, value: isValid)
                }
            }

            // MARK: - Password Requirements
            if type == .password,
               showPasswordRequirements,
               let requirements = passwordRequirements {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Must contain at least:")
                        .font(.system(size: 14))
                        .foregroundStyle(.primary.opacity(0.7))

                    PasswordRequirementRow(
                        text: "At least 1 uppercase",
                        isMet: requirements.hasUppercase
                    )

                    PasswordRequirementRow(
                        text: "At least 1 number",
                        isMet: requirements.hasNumber
                    )

                    PasswordRequirementRow(
                        text: "At least 8 characters",
                        isMet: requirements.hasMinLength
                    )
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: text) {
            guard type == .password else { return }

            if !text.isEmpty && !isValid {
                showPasswordRequirements = true
            } else if text.isEmpty {
                showPasswordRequirements = false
            }
        }
        .onChange(of: isValid) {
            guard type == .password, isValid else { return }

            // Small delay before hiding, so the last checkmark animation is visible
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    showPasswordRequirements = false
                }
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
                .foregroundStyle(isMet ? Color.green : Color.gray.opacity(0.4))
                .font(.system(size: 16))
                .symbolEffect(.bounce, value: isMet)

            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
}

// MARK: - Form Styling

extension View {
    func fieldStyle(isFocused: Bool) -> some View {
        self
            .frame(height: 60)
            .padding(.horizontal, 16)
            .font(.system(size: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.accentColor : Color.gray.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
    }
}


// MARK: - Preview

#Preview("All Fields - Sign Up Form") {
    @Previewable @State var viewModel = AuthViewModel()
    @Previewable @State var birthDate: Date?

    VStack(spacing: 20) {
        InputField(
            placeholder: "Full Name",
            type: .name,
            text: $viewModel.name,
            isValid: viewModel.isNameValid
        )

        InputField(
            placeholder: "Email",
            type: .email,
            text: $viewModel.email,
            isValid: viewModel.isEmailValid
        )
        InputField(
            placeholder: "Birth Date",
            date: $birthDate
        )

        InputField(
            placeholder: "Password",
            type: .password,
            text: $viewModel.password,
            isValid: viewModel.isPasswordValid,
            passwordRequirements: PasswordRequirements(
                hasUppercase: viewModel.hasUppercase,
                hasNumber: viewModel.hasNumber,
                hasMinLength: viewModel.hasMinLength
            )
        )

    }
    .padding()
}
