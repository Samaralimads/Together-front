//
//  PendingProposalCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/04/2026.
//

import SwiftUI

struct PendingProposalCard: View {
    let title: String
    let date: Date
    let partnerName: String
    let note: String?

    var onAccept: () -> Void
    var onRefuse: () -> Void
    var onReschedule: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 6) {
                Image(systemName: "sparkle")
                    .font(.system(.caption2, weight: .bold))
                Text("NEW PROPOSAL FROM \(partnerName.uppercased())")
                    .font(.system(.caption2, weight: .bold))
                    .kerning(0.5)
            }
            .foregroundStyle(Color.cardFill)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color.luckyBlue.opacity(0.9))
            .clipShape(Capsule())

            Text(title)
                .font(.custom("Gaegu-Bold", size: 26, relativeTo: .title))
                .foregroundStyle(Color.charcoal)

            HStack(spacing: 14) {
                Label(date.formatted(.dateTime.month(.abbreviated).day()), systemImage: "calendar")
                Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(Color.charcoal.opacity(0.75))

            if let note {
                Text("\(note)")
                    .font(.footnote)
                    .italic()
                    .foregroundStyle(Color.charcoal.opacity(0.6))
                    .padding(.top, 2)
            }

            HStack(spacing: 10) {
                Button("Accept", action: onAccept)
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(Color.cardFill)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.luckyBlue.opacity(0.9))
                    .clipShape(.rect(cornerRadius: 30))

                Button("Decline", action: onRefuse)
                    .font(.subheadline)
                    .foregroundStyle(Color.charcoal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 30))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.charcoal.opacity(0.15), lineWidth: 1))

                Button("Reschedule", action: onReschedule)
                    .font(.subheadline)
                    .foregroundStyle(Color.charcoal)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 30))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.charcoal.opacity(0.15), lineWidth: 1))
            }
        }
        .padding(20)
        .luckyCard()
    }
}

#Preview {
    Background {
        PendingProposalCard(
            title: "Pottery Workshop",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date.now)!,
            partnerName: "John",
            note: "How about this instead?",
            onAccept: {},
            onRefuse: {},
            onReschedule: {}
        )
        .padding()
    }
}
