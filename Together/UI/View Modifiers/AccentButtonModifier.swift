//
//  AccentButtonModifier.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/02/2026.
//

import SwiftUI

struct AccentButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Image("buttonBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill))
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.13), radius: 2, x: 0, y: 4)
    }
}

