//
//  DashboardViewModel.swift
//  Together
//
//  Created by Samara Lima da Silva on 01/06/2026.
//

import Foundation

@Observable
class DashboardViewModel {
    var user: User? = nil
    var couple: Couple? = nil
    var nextDate: PlannedActivity? = nil
    var pendingProposals: [PlannedActivity] = []
    var isLoading = false

    // MARK: - Load
    func load() async {
        isLoading = true

        do { user = try await ProfileService.fetchMe() } catch { print("Dashboard user error: \(error)") }
        do { couple = try await ProfileService.fetchCouple() } catch { couple = nil }
        await loadActivities()

        isLoading = false
    }

    func loadActivities() async {
        do {
            let all = try await PlannedActivityService.getCoupleActivities()
            let now = Date()

            // Next upcoming accepted date
            nextDate = all
                .filter { $0.isAccepted && ($0.parsedDate ?? Date.distantPast) > now }
                .sorted { ($0.parsedDate ?? Date.distantPast) < ($1.parsedDate ?? Date.distantPast) }
                .first

            // Pending proposals from partner (not from me)
            pendingProposals = all
                .filter { $0.isPending && $0.plannedByUserId != user?.id }
                .sorted { ($0.parsedDate ?? Date.distantPast) < ($1.parsedDate ?? Date.distantPast) }
        } catch {
            print("Dashboard activities error: \(error)")
        }
    }

    // MARK: - Accept
    func accept(proposal: PlannedActivity) async {
        do {
            _ = try await PlannedActivityService.accept(id: proposal.id)
            await loadActivities()
        } catch {
            print("Accept error: \(error)")
        }
    }

    // MARK: - Decline
    func decline(proposal: PlannedActivity) async {
        do {
            _ = try await PlannedActivityService.decline(id: proposal.id)
            await loadActivities()
        } catch {
            print("Decline error: \(error)")
        }
    }

    // MARK: - Reschedule
    func reschedule(proposal: PlannedActivity, newDate: Date, note: String?) async {
        do {
            _ = try await PlannedActivityService.reschedule(id: proposal.id, newDate: newDate, note: note)
            await loadActivities()
        } catch {
            print("Reschedule error: \(error)")
        }
    }

    // MARK: - Helpers
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default:      return "Good Evening"
        }
    }

    var isPaired: Bool { couple?.partner != nil }
    var firstName: String { user?.firstName ?? "" }
    var partnerName: String { couple?.partner?.firstName ?? "" }
}
