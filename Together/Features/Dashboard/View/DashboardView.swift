//
//  DashboardView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    @State private var showInvitePartner = false
    @State private var showInviteBannerDismissed = false
    @State private var proposalToReschedule: PlannedActivity? = nil

    var body: some View {
        Background {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    headerSection

                    if !viewModel.isPaired && !showInviteBannerDismissed {
                        inviteBanner
                    }

                    if let nextDate = viewModel.nextDate {
                        nextDateCard(for: nextDate)
                    } else {
                        emptyNextDateCard
                    }

                    ForEach(viewModel.pendingProposals) { proposal in
                        PendingProposalCard(
                            title: proposal.activityTitle,
                            date: proposal.parsedDate ?? Date(),
                            partnerName: viewModel.partnerName,
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
        .navigationDestination(isPresented: $showInvitePartner) {
            ShareCodePairingView()
        }
        .sheet(item: $proposalToReschedule) { proposal in
            RescheduleSheet(proposal: proposal, partnerName: viewModel.partnerName) { newDate, note in
                Task { await viewModel.reschedule(proposal: proposal, newDate: newDate, note: note) }
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
                .foregroundColor(.preto.opacity(0.6))
                .kerning(1)
            Text(viewModel.firstName)
                .font(.custom("IvyJournal-Bold", size: 30))
                .foregroundColor(.preto)
        }
    }

    var inviteBanner: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    HStack(spacing: 1) {
                        Text("It's always better ")
                            .font(.system(size: 18))
                            .foregroundColor(.preto)
                        Text("Together")
                            .font(.custom("IvyJournal-Bold", size: 18))
                            .foregroundColor(.preto)
                    }

                    Text("Send an invitation code to your partner and once connected you can book activities together.")
                        .font(.subheadline)
                        .foregroundColor(.preto.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                Button("Invite your partner") {
                    showInvitePartner = true
                }
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
                    .foregroundColor(.preto.opacity(0.5))
                    .padding(10)
            }
        }
    }

    func nextDateCard(for activity: PlannedActivity) -> some View {
        let date = activity.parsedDate ?? Date()
        let days = max(Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0, 0)

        return VStack(alignment: .leading, spacing: 12) {
            Text("YOUR NEXT DATE")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .kerning(1)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.activityTitle)
                        .font(.custom("IvyJournal-Bold", size: 22))
                        .foregroundColor(.preto)

                    HStack(spacing: 8) {
                        Label(date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()), systemImage: "calendar")
                        Label(date.formatted(.dateTime.hour().minute()), systemImage: "clock")
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                }

                Spacer()

                VStack {
                    Text("\(days)")
                        .font(.custom("IvyJournal-Bold", size: 48))
                        .foregroundColor(.preto)
                    Text("DAYS TO GO")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .kerning(0.5)
                }
            }

            Button("Details →") {
                // TODO: navigate to activity detail
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.branco)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.preto)
            .cornerRadius(20)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.branco))
    }

    var emptyNextDateCard: some View {
        VStack(spacing: 10) {
            Text("No date planned yet")
                .font(.system(size: 15))
                .foregroundColor(.secondary)

            Text("🤔")
                .font(.system(size: 30))

            Text("Let's find something fun to do!")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.secondary)

            NavigationLink(destination: ActivityView()) {
                Text("Find an activity")
            }
            .modifier(AccentButtonModifier())
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.branco))
    }
}

// MARK: - Reschedule Sheet
struct RescheduleSheet: View {
    let proposal: PlannedActivity
    let partnerName: String
    let onSend: (Date, String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var newDate = Date()
    @State private var note = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("PROPOSE NEW TIME")
                    .font(.system(size: 12, weight: .semibold))
                    .kerning(1)
                    .foregroundColor(.secondary)

                Text(proposal.activityTitle)
                    .font(.custom("IvyJournal-Italic", size: 28))
                    .foregroundColor(.preto)

                if let originalDate = proposal.parsedDate {
                    Text("\(partnerName) suggested \(originalDate.formatted(.dateTime.month(.abbreviated).day())) · \(originalDate.formatted(.dateTime.hour().minute()))")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                // Date picker
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("DATE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .kerning(0.5)
                        DatePicker("", selection: $newDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Note field
                TextField("Add a note for \(partnerName) (optional)", text: $note)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                Spacer()

                HStack(spacing: 12) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(30)

                    Button("Send proposal") {
                        onSend(newDate, note.isEmpty ? nil : note)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.preto)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
            }
            .padding(24)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
