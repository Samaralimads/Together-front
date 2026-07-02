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
                    .font(.system(size: 11, weight: .bold))
                Text("NEW PROPOSAL FROM \(partnerName.uppercased())")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(0.5)
            }
            .foregroundStyle(Color.branco)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.preto)
            .clipShape(Capsule())

            Text(title)
                .font(.custom("IvyJournal-Italic", size: 26))
                .foregroundStyle(Color.preto)

            HStack(spacing: 14) {
                Label(date.formatted(.dateTime.month(.abbreviated).day()), systemImage: "calendar")
                Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
            }
            .font(.system(size: 15))
            .foregroundStyle(Color.preto.opacity(0.75))

            if let note {
                Text("\(note)")
                    .font(.system(size: 14))
                    .italic()
                    .foregroundStyle(Color.preto.opacity(0.6))
                    .padding(.top, 2)
            }

            HStack(spacing: 10) {
                Button("Accept", action: onAccept)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.branco)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .clipShape(.rect(cornerRadius: 30))

                Button("Decline", action: onRefuse)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.preto)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.branco.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 30))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.branco.opacity(0.45), lineWidth: 1))

                Button("Reschedule", action: onReschedule)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.preto)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.branco.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 30))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.branco.opacity(0.45), lineWidth: 1))
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(.thinMaterial))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.preto, lineWidth: 1))
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
