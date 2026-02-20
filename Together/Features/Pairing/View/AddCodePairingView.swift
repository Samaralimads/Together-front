//
//  AddCodePairingView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct AddCodePairingView: View {
    @State private var code: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        Background{
            WhiteCard(title: "Have a pairing code?", description: "If your partner invited you to join them, enter  their unique 6 character pairing code bellow."){
                
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
                
                Button("Confirm") {
                    
                }
                .modifier(AccentButtonModifier())
                
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
            isFocused = true
        }
        .onChange(of: code) { _, newValue in
            if newValue.count > 6 {
                code = String(newValue.prefix(6))
            }
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
}
