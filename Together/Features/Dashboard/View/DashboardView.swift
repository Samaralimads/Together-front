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
    @State private var navigateToDetail = false
    @State private var detailActivity: Activity? = nil

    var body: some View {
        @Bindable var viewModel = viewModel

        Background {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection

                    if !viewModel.isPaired && !showInviteBannerDismissed {
                        inviteBanner
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }

                    if let nextDate = viewModel.nextDate {
                        NextDateCard(
                            planned: nextDate,
                            onDetails: { openDetails(for: nextDate) },
                            onAddToCalendar: { addToCalendar(nextDate) }
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
                            onAccept: { accept(proposal) },
                            onRefuse: { decline(proposal) },
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
            if let activity = detailActivity {
                ActivityDetailView(activity: activity)
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
        .alert("Calendar Error", isPresented: $viewModel.showCalendarError) { } message: {
            Text(viewModel.calendarError ?? "")
        }
    }

    // MARK: - Actions
    private func openDetails(for planned: PlannedActivity) {
        Task {
            guard let activity = await viewModel.fetchActivity(id: planned.activityId) else { return }
            detailActivity = activity
            navigateToDetail = true
        }
    }

    private func addToCalendar(_ planned: PlannedActivity) {
        Task { await viewModel.addToCalendar(planned: planned) }
    }

    private func accept(_ proposal: PlannedActivity) {
        Task { await viewModel.accept(proposal: proposal) }
    }

    private func decline(_ proposal: PlannedActivity) {
        Task { await viewModel.decline(proposal: proposal) }
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

#Preview {
    NavigationStack {
        DashboardView()
    }
}
