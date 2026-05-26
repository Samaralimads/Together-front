//
//  ProfileViewModel.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/05/2026.
//

import Foundation
import SwiftUI

@Observable
class ProfileViewModel {
    var user: User? = nil
    var couple: Couple? = nil
    var importantDates: [ImportantDate] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isPaired: Bool { couple?.partner != nil }

    // MARK: - Load all profile data
    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            user = try await ProfileService.fetchMe()
        } catch {
            errorMessage = error.localizedDescription
        }

        do {
            couple = try await ProfileService.fetchCouple()
        } catch {
            couple = nil
        }

        do {
            let dates = try await ProfileService.fetchImportantDates()
            importantDates = dates.map { ImportantDate(id: $0.id, label: $0.label, date: parsedDate($0.date)) }
        } catch {
            importantDates = []
        }

        isLoading = false
    }

    // MARK: - Add important date
    func addImportantDate(label: String, date: Date) async {
        let formatter = dateFormatter()
        do {
            let response = try await ProfileService.createImportantDate(label: label, date: formatter.string(from: date))
            importantDates.append(ImportantDate(id: response.id, label: response.label, date: parsedDate(response.date)))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Update important date
    func updateImportantDate(_ importantDate: ImportantDate) async {
        let formatter = dateFormatter()
        do {
            let response = try await ProfileService.updateImportantDate(
                id: importantDate.id,
                label: importantDate.label,
                date: formatter.string(from: importantDate.date)
            )
            if let index = importantDates.firstIndex(where: { $0.id == importantDate.id }) {
                importantDates[index] = ImportantDate(id: response.id, label: response.label, date: parsedDate(response.date))
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Delete important date
    func deleteImportantDate(_ importantDate: ImportantDate) async {
        do {
            try await ProfileService.deleteImportantDate(id: importantDate.id)
            importantDates.removeAll { $0.id == importantDate.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers
    var anniversaryDate: Date {
        guard let dateString = couple?.relationshipStartDate else { return Date() }
        return parsedDate(dateString)
    }

    var partner1Initial: String {
        String((user?.firstName ?? "?").prefix(1).uppercased())
    }

    var partner2Initial: String? {
        guard let partnerName = couple?.partner?.firstName else { return nil }
        return String(partnerName.prefix(1).uppercased())
    }

    var displayName: String {
        guard let user else { return "" }
        if let partner = couple?.partner {
            return "\(user.firstName) & \(partner.firstName)"
        }
        return user.firstName
    }

    private func dateFormatter() -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }

    private func parsedDate(_ string: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f.date(from: string) ?? Date()
    }
}
