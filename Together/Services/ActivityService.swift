//
//  ActivityService.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/05/2026.
//

import Foundation
 
struct ActivityService {
 
    // MARK: - Models
    struct ActivityResponse: Decodable, Identifiable {
        let id: UUID
        let title: String
        let description: String
        let budget: String
        let duration: Int
        let isIndoor: Bool
        let categoryId: UUID
    }
 
    struct CategoryResponse: Decodable, Identifiable {
        let id: UUID
        let name: String
        let imageUrl: String
    }
 
    // MARK: - Fetch all activities with optional filters
    static func fetchActivities(
        category: String? = nil,
        search: String? = nil,
        budget: String? = nil,
        duration: String? = nil,
        location: String? = nil
    ) async throws -> [ActivityResponse] {
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
        return try decoder.decode([ActivityResponse].self, from: data)
    }
 
    // MARK: - Fetch single activity
    static func fetchActivity(id: UUID) async throws -> ActivityResponse {
        return try await APIClient.shared.request("/activities/\(id.uuidString)", requiresAuth: false)
    }
 
    // MARK: - Fetch all categories
    static func fetchCategories() async throws -> [CategoryResponse] {
        return try await APIClient.shared.request("/categories", requiresAuth: false)
    }
}
