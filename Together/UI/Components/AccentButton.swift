//
//  AccentButton.swift
//  Together
//
//  Created by Samara Lima da Silva on 10/02/2026.
//

import SwiftUI

struct AccentButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
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
}



#Preview {
    AccentButton(title: "Sign up") {
        print("Tapped")
    }
}

