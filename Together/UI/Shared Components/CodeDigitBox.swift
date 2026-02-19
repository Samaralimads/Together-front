//
//  CodeDigitBox.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct CodeDigitBox: View {
        let digit: String
        let isActive: Bool

        var body: some View {
            Text(digit)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 50, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isActive ? Color.accent : Color.cinza,
                            lineWidth: 1.5
                        )
                )
                .cornerRadius(12)
        }
    }

#Preview {
    HStack {
    CodeDigitBox(digit: "3", isActive: true)
    CodeDigitBox(digit: "", isActive: false)
    }
}
