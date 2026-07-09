//
//  DashboardViewModel.swift
//  Together
//
//  Created by Samara Lima da Silva on 01/06/2026.
//

import Foundation
import EventKit

@Observable
class DashboardViewModel {
    var user: User? = nil
    var couple: Couple? = nil
    var nextDate: PlannedActivity? = nil
    var pendingProposals: [PlannedActivity] = []
    var isLoading = false
    var errorMessage: String? = nil
    var calendarError: String? = nil
    var showCalendarError = false

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
            let now = Date.now

            nextDate = all
                .filter { $0.isAccepted && ($0.parsedDate ?? .distantPast) > now }
                .sorted { ($0.parsedDate ?? .distantPast) < ($1.parsedDate ?? .distantPast) }
                .first

            pendingProposals = all
                .filter { $0.isPending && $0.plannedByUserId != user?.id }
                .sorted { ($0.parsedDate ?? .distantPast) < ($1.parsedDate ?? .distantPast) }
        } catch {
            print("Dashboard activities error: \(error)")
            errorMessage = "Could not load your dates. Please try again."
        }
    }

    // MARK: - Accept
    func accept(proposal: PlannedActivity) async {
        errorMessage = nil
        do {
            _ = try await PlannedActivityService.accept(id: proposal.id)
            await loadActivities()
        } catch {
            print("Accept error: \(error)")
            errorMessage = "Could not accept the proposal. Please try again."
        }
    }

    // MARK: - Decline
    func decline(proposal: PlannedActivity) async {
        errorMessage = nil
        do {
            _ = try await PlannedActivityService.decline(id: proposal.id)
            await loadActivities()
        } catch {
            print("Decline error: \(error)")
            errorMessage = "Could not decline the proposal. Please try again."
        }
    }

    // MARK: - Reschedule
    func reschedule(proposal: PlannedActivity, newDate: Date, note: String?) async {
        errorMessage = nil
        do {
            _ = try await PlannedActivityService.reschedule(id: proposal.id, newDate: newDate, note: note)
            await loadActivities()
        } catch {
            print("Reschedule error: \(error)")
            errorMessage = "Could not send your proposal. Please try again."
        }
    }

    // MARK: - Activity Detail
    func fetchActivity(id: UUID) async -> Activity? {
        do {
            return try await ActivityService.fetchActivity(id: id)
        } catch {
            print("Fetch activity error: \(error)")
            errorMessage = "Could not load the activity details."
            return nil
        }
    }

    // MARK: - Calendar
    func addToCalendar(planned: PlannedActivity) async {
        guard let date = planned.parsedDate else { return }
        let store = EKEventStore()

        do {
            guard try await store.requestFullAccessToEvents() else {
                calendarError = "Please allow calendar access in Settings."
                showCalendarError = true
                return
            }

            let event = EKEvent(eventStore: store)
            event.title = planned.activityTitle
            event.startDate = date
            event.endDate = date.addingTimeInterval(3600)
            event.calendar = store.defaultCalendarForNewEvents

            try store.save(event, span: .thisEvent)
        } catch {
            print("Calendar error: \(error)")
            calendarError = "Could not add to calendar. Please try again."
            showCalendarError = true
        }
    }

    // MARK: - Helpers
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date.now)
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
