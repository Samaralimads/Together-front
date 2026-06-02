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

    var onAccept: () -> Void
    var onRefuse: () -> Void
    var onReschedule: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: Label
//            HStack(spacing: 6) {
//                Image(systemName: "sparkle")
//                    .font(.system(size: 11, weight: .bold))
//                Text("NEW PROPOSAL FROM \(partnerName.uppercased())")
//                    .font(.system(size: 11, weight: .bold))
//                    .kerning(0.5)
//            }
//            .foregroundColor(.white)
//            .padding(.horizontal)
//            .padding(.vertical, 5)
//            .background(
//                Image("buttonBG")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill))
//            .clipShape(Capsule())
            

            HStack(spacing: 6) {
                Image(systemName: "sparkle")
                    .font(.system(size: 11, weight: .bold))
                Text("NEW PROPOSAL FROM \(partnerName.uppercased())")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(0.5)
            }
            .foregroundColor(.branco)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(.preto)
            .clipShape(Capsule())
            
            // MARK: Activity title
            Text(title)
                .font(.custom("IvyJournal-Italic", size: 26))
                .foregroundColor(.preto)

            // MARK: Date / time / location
            HStack(spacing: 14) {
                Label(date.formatted(.dateTime.month(.abbreviated).day()), systemImage: "calendar")
                Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
            }
            .font(.system(size: 15))
            .foregroundColor(.preto.opacity(0.75))

            // MARK: Actions
            HStack(spacing: 10) {
                Button("Accept", action: onAccept)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.branco)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .cornerRadius(30)

                Button("Decline", action: onRefuse)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.preto)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.branco.opacity(0.15))
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.branco.opacity(0.45), lineWidth: 1))

                Button("Reschedule", action: onReschedule)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.preto)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.branco.opacity(0.15))
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.branco.opacity(0.45), lineWidth: 1))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.thinMaterial)
        )
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.preto, lineWidth: 1))
    }
}

#Preview {
    Background {
        PendingProposalCard(
            title: "Pottery Workshop",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            partnerName: "John",
            onAccept: {},
            onRefuse: {},
            onReschedule: {}
        )
        .padding()
    }
}
