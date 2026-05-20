//
//  ShareCodePairingView.swift
//  Together
//
//  Created by Samara Lima da Silva on 13/02/2026.
//

import SwiftUI

struct ShareCodePairingView: View {
    @State private var code = ""
    @State private var isLoading = true
    @State private var navigateToAnniversary = false

    var body: some View {
        Background {
            WhiteCard(title: "First one here?", description: "Share this code with your partner to connect your accounts and start planning activities together.") {

                if isLoading {
                    ProgressView()
                        .padding(.vertical, 40)
                } else {
                    HStack(spacing: 10) {
                        ForEach(Array(code), id: \.self) { character in
                            CodeDigitBox(digit: String(character), isActive: false)
                        }
                    }
                    .padding(.vertical, 40)

                    ShareLink(
                        item: code,
                        subject: Text("Pairing Code"),
                        message: Text("Join me using this pairing code: \(code)")
                    ) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Code")
                        }
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

                    Button("Next") {
                        navigateToAnniversary = true
                    }
                    .font(.footnote)
                    .foregroundColor(.accent)
                    .fontWeight(.semibold)
                    .padding(.top, 16)
                }
            }
        }
        .task {
            do {
                let invitation = try await CoupleService.getMyInvitationCode()
                code = invitation.code
            } catch {
                code = "------"
            }
            isLoading = false
        }
        .navigationDestination(isPresented: $navigateToAnniversary) {
            AnniversaryView()
        }
    }
}

#Preview {
    ShareCodePairingView()
        .environment(AppState())
}
