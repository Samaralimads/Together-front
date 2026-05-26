//
//  ActivityService.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/05/2026.
//

import Foundation
 
struct ActivityService {

    // MARK: - Fetch all activities with optional filters
    static func fetchActivities(
        category: String? = nil,
        search: String? = nil,
        budget: String? = nil,
        duration: String? = nil,
        location: String? = nil
    ) async throws -> [Activity] {
        var components = URLComponents(string: "http://127.0.0.1:8080/activities")!
        var queryItems: [URLQueryItem] = []

        if let category  { queryItems.append(URLQueryItem(name: "category", value: category)) }
        if let search    { queryItems.append(URLQueryItem(name: "search", value: search)) }
        if let budget    { queryItems.append(URLQueryItem(name: "budget", value: budget)) }
        if let duration  { queryItems.append(URLQueryItem(name: "duration", value: duration)) }
        if let location  { queryItems.append(URLQueryItem(name: "location", value: location)) }
 
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
 
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(0, "Failed to fetch activities.")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Activity].self, from: data)
    }

    // MARK: - Fetch single activity
    static func fetchActivity(id: UUID) async throws -> Activity {
        return try await APIClient.shared.request("/activities/\(id.uuidString)", requiresAuth: false)
    }
 
    // MARK: - Fetch all categories
    static func fetchCategories() async throws -> [Category] {
        return try await APIClient.shared.request("/categories", requiresAuth: false)
    }

    // MARK: - Favorites
    static func fetchFavorites() async throws -> [Activity] {
        return try await APIClient.shared.request("/favorites")
    }

    static func addFavorite(activityId: UUID) async throws {
        try await APIClient.shared.requestEmpty("/favorites/\(activityId.uuidString)", method: "POST")
    }

    static func removeFavorite(activityId: UUID) async throws {
        try await APIClient.shared.requestEmpty("/favorites/\(activityId.uuidString)", method: "DELETE")
    }
}
