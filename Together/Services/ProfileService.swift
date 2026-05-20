//
//  ProfileService.swift
//  Together
//
//  Created by Samara Lima da Silva on 20/05/2026.
//

import Foundation

struct ProfileService {

    // MARK: - Models
    struct UserResponse: Decodable {
        let id: UUID
        let firstName: String
        let birthDate: String
        let email: String
        let profilePicture: String?
    }

    struct CoupleResponse: Decodable {
        let id: UUID
        let relationshipStartDate: String
        let partner: PartnerResponse
    }

    struct PartnerResponse: Decodable {
        let id: UUID
        let firstName: String
    }

    struct ImportantDateResponse: Decodable, Identifiable {
        let id: UUID
        let label: String
        let date: String
    }

    struct UpdateUserRequest: Encodable {
        let firstName: String?
        let email: String?
        let profilePicture: String?
    }

    struct ImportantDateRequest: Encodable {
        let label: String
        let date: String
    }

    // MARK: - Fetch current user
    static func fetchMe() async throws -> UserResponse {
        return try await APIClient.shared.request("/users/me")
    }

    // MARK: - Update current user
    static func updateMe(firstName: String? = nil, email: String? = nil, profilePicture: String? = nil) async throws -> UserResponse {
        let body = UpdateUserRequest(firstName: firstName, email: email, profilePicture: profilePicture)
        return try await APIClient.shared.request("/users/me", method: "PUT", body: body)
    }

    // MARK: - Fetch couple
    static func fetchCouple() async throws -> CoupleResponse {
        return try await APIClient.shared.request("/couples/me")
    }

    // MARK: - Fetch important dates
    static func fetchImportantDates() async throws -> [ImportantDateResponse] {
        return try await APIClient.shared.request("/important-dates")
    }

    // MARK: - Create important date
    static func createImportantDate(label: String, date: String) async throws -> ImportantDateResponse {
        let body = ImportantDateRequest(label: label, date: date)
        return try await APIClient.shared.request("/important-dates", method: "POST", body: body)
    }

    // MARK: - Update important date
    static func updateImportantDate(id: UUID, label: String, date: String) async throws -> ImportantDateResponse {
        let body = ImportantDateRequest(label: label, date: date)
        return try await APIClient.shared.request("/important-dates/\(id.uuidString)", method: "PUT", body: body)
    }

    // MARK: - Delete important date
    static func deleteImportantDate(id: UUID) async throws {
        try await APIClient.shared.requestEmpty("/important-dates/\(id.uuidString)", method: "DELETE")
    }
}
