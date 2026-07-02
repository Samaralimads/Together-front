//
//  DashboardView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI
import EventKit

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @State private var showInvitePartner = false
    @State private var showInviteBannerDismissed = false
    @State private var proposalToReschedule: PlannedActivity? = nil
    @State private var navigateToDetail = false
    @State private var detailActivity: Activity? = nil
    @State private var detailCategory: Category? = nil
    @State private var calendarError: String? = nil

    var body: some View {
        Background {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection

                    if !viewModel.isPaired && !showInviteBannerDismissed {
                        inviteBanner
                    }

                    if let nextDate = viewModel.nextDate {
                        NextDateCard(
                            planned: nextDate,
                            onDetails: {
                                Task { await fetchAndNavigate(activityId: nextDate.activityId) }
                            },
                            onAddToCalendar: {
                                addToCalendar(planned: nextDate)
                            }
                        )
                    } else {
                        EmptyNextDateCard()
                    }

                    ForEach(viewModel.pendingProposals) { proposal in
                        PendingProposalCard(
                            title: proposal.activityTitle,
                            date: proposal.parsedDate ?? Date.now,
                            partnerName: viewModel.partnerName,
                            note: proposal.note,
                            onAccept: { Task { await viewModel.accept(proposal: proposal) } },
                            onRefuse: { Task { await viewModel.decline(proposal: proposal) } },
                            onReschedule: { proposalToReschedule = proposal }
                        )
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .task { await viewModel.load() }
        .navigationDestination(isPresented: $navigateToDetail) {
            if let activity = detailActivity, let category = detailCategory {
                ActivityDetailView(activity: activity, category: category)
            }
        }
        .navigationDestination(isPresented: $showInvitePartner) {
            ShareCodePairingView()
        }
        .sheet(item: $proposalToReschedule) { proposal in
            RescheduleSheet(proposal: proposal, partnerName: viewModel.partnerName) { newDate, note in
                Task { await viewModel.reschedule(proposal: proposal, newDate: newDate, note: note) }
            }
        }
        .alert("Calendar Error", isPresented: .constant(calendarError != nil)) {
            Button("OK") { calendarError = nil }
        } message: {
            Text(calendarError ?? "")
        }
    }

    private func fetchAndNavigate(activityId: UUID) async {
        do {
            let activity = try await ActivityService.fetchActivity(id: activityId)
            let category = Category(id: activity.categoryId, name: "")
            detailActivity = activity
            detailCategory = category
            navigateToDetail = true
        } catch {
            print("Fetch activity error: \(error)")
        }
    }

    private func addToCalendar(planned: PlannedActivity) {
        guard let date = planned.parsedDate else { return }
        let store = EKEventStore()

        store.requestFullAccessToEvents { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    calendarError = "Please allow calendar access in Settings."
                }
                return
            }

            let event = EKEvent(eventStore: store)
            event.title = planned.activityTitle
            event.startDate = date
            event.endDate = date.addingTimeInterval(3600)
            event.calendar = store.defaultCalendarForNewEvents

            do {
                try store.save(event, span: .thisEvent)
            } catch {
                DispatchQueue.main.async {
                    calendarError = "Could not add to calendar. Please try again."
                }
            }
        }
    }
}

// MARK: - Subviews
private extension DashboardView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.greeting.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.preto.opacity(0.6))
                .kerning(1)
            Text(viewModel.firstName)
                .font(.custom("IvyJournal-Bold", size: 30))
                .foregroundStyle(Color.preto)
        }
    }

    var inviteBanner: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    HStack(spacing: 1) {
                        Text("It's always better ")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.preto)
                        Text("Together")
                            .font(.custom("IvyJournal-Bold", size: 18))
                            .foregroundStyle(Color.preto)
                    }
                    Text("Send an invitation code to your partner and once connected you can book activities together.")
                        .font(.subheadline)
                        .foregroundStyle(Color.preto.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                Button("Invite your partner") { showInvitePartner = true }
                    .modifier(AccentButtonModifier())
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 24).fill(.thinMaterial))

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showInviteBannerDismissed = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.preto.opacity(0.5))
                    .padding(10)
            }
        }
    }
}

// MARK: - Next Date Card

// MARK: - Empty Next Date Card


// MARK: - Reschedule Sheet
struct RescheduleSheet: View {
    let proposal: PlannedActivity
    let partnerName: String
    let onSend: (Date, String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var newDate = Date.now
    @State private var newTime = Date.now
    @State private var note = ""

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

                    Button("Send proposal") {
                        let combined = combinedDate(date: newDate, time: newTime)
                        onSend(combined, note.isEmpty ? nil : note)
                        dismiss()
                    }
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
    NavigationStack {
        DashboardView()
    }
}
