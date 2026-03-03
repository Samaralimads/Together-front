//
//  DashboardView.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/02/2026.
//

import SwiftUI

// MARK: - Mock State (replace with real VM later)
enum PartnerStatus {
    case notPaired
    case paired(name: String)
}

enum ActivityStatus {
    case none
    case planned(title: String, date: Date)
    case pendingProposal(title: String, date: Date)
}

struct DashboardView: View {
    
    // TODO: Replace with real ViewModel
    @State private var userName = "Sarah"
    @State private var partnerStatus: PartnerStatus = .notPaired
    @State private var activityStatus: ActivityStatus = .pendingProposal(title: "Hiking", date: Date())
    @State private var showInvitePartner = false
    @State private var showInviteBannerDismissed = false
    
    var body: some View {
        Background {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Header
                    headerSection
                    
                    // MARK: Invite banner (if not paired and not dismissed)
                    if case .notPaired = partnerStatus {
                        if !showInviteBannerDismissed {
                            inviteBanner
                        }
                    }
                    
                    // MARK: Next date card
                    nextDateCard
                    
                    // MARK: Pending proposal (if any)
                    if case .pendingProposal(let title, let date) = activityStatus,
                       case .paired(let partnerName) = partnerStatus {
                        pendingProposalCard(title: title, date: date, partnerName: partnerName)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
//                .padding(.top, 60)
                .padding(.bottom, 40)
            }
        }
        .navigationDestination(isPresented: $showInvitePartner) {
            ShareCodePairingView()
        }
    }
}


// MARK: - Subviews
private extension DashboardView {
    
    // MARK: Header
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Hello, \(userName)")
                .font(.custom("IvyJournal-Bold", size: 30))
                .foregroundColor(.preto)
            
            Text("Ready for your next date?")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.branco)
        }
    }
    
    // MARK: Invite Banner
    var inviteBanner: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                VStack(spacing: 10) {
                    HStack(spacing: 1){
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
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.branco.opacity(0.7))
            )
            
            // Dismiss button
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showInviteBannerDismissed = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.preto.opacity(0.5))
                    .padding(15)
            }
        }
    }
    
    // MARK: Next Date Card
    var nextDateCard: some View {
        VStack(spacing: 16) {
            switch activityStatus {
                
            case .none:
                // Empty state
                VStack(spacing: 10) {
                    Text("No date planned yet")
                        .font(.subheadline)
                        .foregroundColor(.preto.opacity(0.9))

                    
                    Text("🤔")
                        .font(.system(size: 30))
                    
                    Text("Let's find something fun to do!")
                        .font(.subheadline)
                        .foregroundColor(.preto.opacity(0.9))

                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                
                NavigationLink(destination: ActivityView()) {
                    Text("Find an activity")
                }
                .modifier(AccentButtonModifier())
                
            case .planned(let title, let date):
                // Planned state
                VStack(spacing: 8) {
                    Text("Your next date is in")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.secondary)
                    
                    let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
                    
                    Text("\(max(days, 0)) days")
                        .font(.custom("IvyJournal-Bold", size: 38))
                        .foregroundColor(.preto)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.preto)
                    
                    Text(date, style: .date)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                
                Button("View details") {
                    // TODO: navigate to activity detail
                }
                .modifier(AccentButtonModifier())
                
            case .pendingProposal:
                // When proposal, show empty state still in this card
                VStack(spacing: 10) {
                    Text("No confirmed date yet")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: ActivityView()) {
                        Text("Find an activity")
                    }
                    .modifier(AccentButtonModifier())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.branco)
        )
    }
    
    // MARK: Pending Proposal Card
    func pendingProposalCard(title: String, date: Date, partnerName: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.accent)
                Text("Proposal received")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accent)
                Spacer()
            }
            
            Text(title)
                .font(.custom("IvyJournal-Bold", size: 20))
                .foregroundColor(.preto)
            
            HStack(spacing: 16) {
                Label(date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Label("by \(partnerName)", systemImage: "person.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Button("Refuse") {
                    // TODO: refuse
                }
                .fontWeight(.semibold)
                .foregroundColor(.preto)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.cinza.opacity(0.4))
                .cornerRadius(30)
                
                Button("Accept") {
                    // TODO: accept
                }
                .modifier(AccentButtonModifier())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.branco)
        )
    }
}

#Preview{
    NavigationStack {
        DashboardView()
    }
}


