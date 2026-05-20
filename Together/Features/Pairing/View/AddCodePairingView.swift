//
//  AddCodePairingView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct AddCodePairingView: View {
    @State private var code: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var navigateToPairingSuccess = false
    @FocusState private var isFocused: Bool

    var body: some View {
        Background {
            WhiteCard(title: "Have a pairing code?", description: "If your partner invited you to join them, enter their unique 6 character pairing code below.") {

                HStack(spacing: 10) {
                    ForEach(0..<6) { index in
                        CodeDigitBox(
                            digit: digit(at: index),
                            isActive: code.count == index
                        )
                    }
                }
                .padding(.vertical, 40)

                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .opacity(0)
                    .frame(height: 0)

                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                }

                Button(isLoading ? "Confirming..." : "Confirm") {
                    Task {
                        isLoading = true
                        errorMessage = nil
                        do {
                            _ = try await CoupleService.joinCouple(invitationCode: code)
                            navigateToPairingSuccess = true
                        } catch {
                            print("Join couple error: \(error)")
                            errorMessage = "Invalid or expired code. Please check and try again."
                        }
                        isLoading = false
                    }
                }
                .modifier(AccentButtonModifier())
                .disabled(code.count < 6 || isLoading)
                .opacity(code.count < 6 ? 0.6 : 1)

                NavigationLink("I'm the first one here") {
                    ShareCodePairingView()
                }
                .font(.footnote)
                .foregroundColor(.accent)
                .fontWeight(.semibold)
                .padding(.top, 30)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .onChange(of: code) { _, newValue in
            if newValue.count > 6 {
                code = String(newValue.prefix(6))
            }
        }
        .navigationDestination(isPresented: $navigateToPairingSuccess) {
            PairingSucessfulView()
        }
    }

    private func digit(at index: Int) -> String {
        guard index < code.count else { return "" }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[stringIndex])
    }
}

#Preview {
    AddCodePairingView()
        .environment(AppState())
}
