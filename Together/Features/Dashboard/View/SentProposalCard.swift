//
//  SentProposalCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 28/09/2026.
//

import SwiftUI

struct SentProposalCard: View {
    let title: String
    let date: Date
    let partnerName: String

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(.caption2, weight: .bold))
                    Text("WAITING FOR \(partnerName.uppercased())")
                        .font(.system(.caption2, weight: .bold))
                        .kerning(0.5)
                }
                .foregroundStyle(Color.branco)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.lilas.opacity(0.9))
                .clipShape(Capsule())

                Text(title)
                    .font(.custom("IvyJournal-Bold", size: 18, relativeTo: .headline))
                    .foregroundStyle(Color.preto)

                HStack(spacing: 10) {
                    Label(date.formatted(.dateTime.month(.abbreviated).day()), systemImage: "calendar")
                    Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "clock")
                .font(.body)
                .foregroundStyle(Color.preto.opacity(0.4))
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 24).fill(.branco))
    }
}

#Preview {
    Background {
        SentProposalCard(
            title: "Pottery Workshop",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date.now)!,
            partnerName: "Alex"
        )
        .padding()
    }
}
