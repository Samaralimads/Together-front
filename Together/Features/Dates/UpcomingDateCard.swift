//
//  UpcomingDateCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 09/07/2026.
//

import SwiftUI

struct UpcomingDateCard: View {
    let planned: PlannedActivity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(planned.activityTitle)
                .font(.custom("Gaegu-Bold", size: 20))
                .foregroundStyle(Color.charcoal)

            if let date = planned.parsedDate {
                HStack(spacing: 8) {
                    Label(date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()), systemImage: "calendar")
                    Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
                }
                .font(.luckyCaption)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardFill)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 5)
    }
}

#Preview {
    UpcomingDateCard(
        planned: PlannedActivity(
            id: UUID(),
            activityId: UUID(),
            activityTitle: "Sunset Kayaking",
            coupleId: UUID(),
            plannedByUserId: UUID(),
            proposedDate: "2026-07-10 18:30",
            responseDate: nil,
            bookingStatus: "accepted",
            reminderEnabled: false,
            reminderDaysBefore: nil,
            note: nil,
            createdAt: nil
        )
    )
    .padding()
    .background { Image("LuckyBackground").resizable().scaledToFill().ignoresSafeArea() }
}
