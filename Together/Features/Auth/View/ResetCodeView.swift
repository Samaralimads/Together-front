//
//  ResetCodeView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import Combine

struct ResetCodeView: View {
    let email: String
    @State private var code: String = ""
    @State private var timeRemaining: Int = 600 // 10 minutes in seconds
    @State private var timerExpired: Bool = false
    @FocusState private var isFocused: Bool

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Background {
            WhiteCard(
                title: "Reset Password",
                description: "A 6-digit code was sent to \(email)"
            ) {
                HStack(spacing: 12) {
                    ForEach(0..<6) { index in
                        CodeDigitBox(
                            digit: digit(at: index),
                            isActive: code.count == index
                        )
                    }
                }
                .padding(.vertical, 40)
                .onTapGesture {
                    isFocused = true
                }

                if timerExpired {
                    Button("Resend code") {
                        // TODO: Call forgot-password again
                    }
                    .font(.footnote)
                    .foregroundColor(.accent)
                    .fontWeight(.semibold)
                } else {
                    Text("Code valid for \(formattedTime)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .contentTransition(.numericText())
                }

                // Hidden TextField
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .opacity(0)
                    .frame(height: 0)
            }
        }
        .onAppear {
            isFocused = true
        }
        .onChange(of: code) { _, newValue in
            if newValue.count > 6 {
                code = String(newValue.prefix(6))
            }
            // TODO: Auto-submit when 6 digits entered
            if newValue.count == 6 {
                isFocused = false
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerExpired = true
            }
        }
    }

    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func digit(at index: Int) -> String {
        guard index < code.count else { return "" }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return String(code[stringIndex])
    }
}

#Preview {
    ResetCodeView(email: "samara@test.com")
}
