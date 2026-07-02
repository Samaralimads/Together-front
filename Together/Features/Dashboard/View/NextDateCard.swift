//
//  NextDateCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/06/2026.
//

import SwiftUI

struct NextDateCard: View {
    let planned: PlannedActivity
    let onDetails: () -> Void
    let onAddToCalendar: () -> Void

    var body: some View {
        let date = planned.parsedDate ?? Date.now
        let days = max(Calendar.current.dateComponents([.day], from: Date.now, to: date).day ?? 0, 0)

        VStack(alignment: .leading, spacing: 12) {
            Text("YOUR NEXT DATE")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .kerning(1)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(planned.activityTitle)
                        .font(.custom("IvyJournal-Bold", size: 22))
                        .foregroundStyle(Color.preto)

                    HStack(spacing: 8) {
                        Label(date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()), systemImage: "calendar")
                        Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 0) {
                    Text("\(days)")
                        .font(.custom("IvyJournal-Bold", size: 48))
                        .foregroundStyle(Color.preto)
                    Text("DAYS TO GO")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .kerning(0.5)
                }
            }

            HStack(spacing: 10) {
                Button(action: onAddToCalendar) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.preto)
                        .frame(width: 44, height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button("Details →", action: onDetails)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.branco)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.preto)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.branco))
    }
}
