//
//  InviteBannerCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct InviteBannerCard: View {
    let onInvite: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    HStack(spacing: 1) {
                        Text("It's always better ")
                            .font(.body)
                            .foregroundStyle(Color.charcoal)
                        Text("Together")
                            .font(.custom("Gaegu-Bold", size: 18, relativeTo: .body))
                            .foregroundStyle(Color.charcoal)
                    }
                    Text("Send an invitation code to your partner and once connected you can book activities together.")
                        .font(.subheadline)
                        .foregroundStyle(Color.charcoal.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                Button("Invite your partner", action: onInvite)
                    .buttonStyle(.luckyPrimary)
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 24).fill(.thinMaterial))

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(.footnote, weight: .semibold))
                    .foregroundStyle(Color.charcoal.opacity(0.5))
                    .padding(10)
            }
        }
    }
}

#Preview {
    Background {
        InviteBannerCard(onInvite: {}, onDismiss: {})
            .padding(20)
    }
}
