//
//  PlannedActivity.swift
//  Together
//
//  Created by Samara Lima da Silva on 01/06/2026.
//

import Foundation

struct PlannedActivity: Codable, Identifiable {
    let id: UUID
    let activityId: UUID
    let activityTitle: String
    let coupleId: UUID?
    let plannedByUserId: UUID
    let proposedDate: String
    let responseDate: String?
    let bookingStatus: String
    let reminderEnabled: Bool
    let reminderDaysBefore: Int?
    let note: String?
    let createdAt: String?

    var parsedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: proposedDate)
    }

    var isPending: Bool { bookingStatus == "pending" }
    var isAccepted: Bool { bookingStatus == "accepted" }
}
