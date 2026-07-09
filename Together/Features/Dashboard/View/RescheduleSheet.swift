//
//  RescheduleSheet.swift
//  Together
//
//  Created by Samara Lima da Silva on 09/07/2026.
//

import SwiftUI

struct RescheduleSheet: View {
    let proposal: PlannedActivity
    let partnerName: String
    let onSend: (Date, String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var newDate: Date
    @State private var newTime: Date
    @State private var note = ""

    init(proposal: PlannedActivity, partnerName: String, onSend: @escaping (Date, String?) -> Void) {
        self.proposal = proposal
        self.partnerName = partnerName
        self.onSend = onSend

        // Start from the partner's suggestion instead of the current moment
        let start = proposal.parsedDate ?? .now
        _newDate = State(initialValue: start)
        _newTime = State(initialValue: start)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("PROPOSE NEW TIME")
                    .font(.system(size: 12, weight: .semibold))
                    .kerning(1)
                    .foregroundStyle(.secondary)

                Text(proposal.activityTitle)
                    .font(.custom("IvyJournal-Italic", size: 28))
                    .foregroundStyle(Color.preto)

                if let originalDate = proposal.parsedDate {
                    Text("\(partnerName) suggested \(originalDate.formatted(.dateTime.month(.abbreviated).day())) · \(originalDate.formatted(.dateTime.hour().minute()))")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Label("", systemImage: "calendar")
                    DatePicker("Date", selection: $newDate, displayedComponents: .date)
                        .labelsHidden()
                        .buttonStyle(.borderless)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(.rect(cornerRadius: 12))

                HStack {
                    Label("", systemImage: "clock")
                    DatePicker("Time", selection: $newTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .buttonStyle(.borderless)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(.rect(cornerRadius: 12))

                TextField("Add a note for \(partnerName) (optional)", text: $note, axis: .vertical)
                    .lineLimit(3...)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                Spacer()

                HStack(spacing: 12) {
                    Button("Cancel") { dismiss() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(.rect(cornerRadius: 30))

                    Button("Send proposal", action: sendProposal)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.preto)
                        .foregroundStyle(Color.white)
                        .clipShape(.rect(cornerRadius: 30))
                }
            }
            .padding(24)
        }
        .presentationDetents([.large])
    }

    // MARK: - Actions
    private func sendProposal() {
        let combined = combinedDate(date: newDate, time: newTime)
        onSend(combined, note.isEmpty ? nil : note)
        dismiss()
    }

    private func combinedDate(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        return calendar.date(from: components) ?? date
    }
}

#Preview {
    RescheduleSheet(
        proposal: PlannedActivity(
            id: UUID(),
            activityId: UUID(),
            activityTitle: "Picnic at the Park",
            coupleId: UUID(),
            plannedByUserId: UUID(),
            proposedDate: "2026-07-10 18:30",
            responseDate: nil,
            bookingStatus: "pending",
            reminderEnabled: false,
            reminderDaysBefore: nil,
            note: "Bring the blanket!",
            createdAt: nil
        ),
        partnerName: "Alex"
    ) { _, _ in }
}
