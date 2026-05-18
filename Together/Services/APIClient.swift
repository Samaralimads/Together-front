//
//  APIClient.swift
//  Together
//
//  Created by Samara Lima da Silva on 18/05/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int, String)
    case unauthorized
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:              return "Invalid URL."
        case .noData:                  return "No data received."
        case .decodingError(let e):    return "Failed to decode response: \(e.localizedDescription)"
        case .serverError(_, let msg): return msg
        case .unauthorized:            return "Session expired. Please log in again."
        case .unknown(let e):          return e.localizedDescription
        }
    }
}

struct APIErrorResponse: Decodable {
    let reason: String
}

final class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://127.0.0.1:8080"

    private init() {}

    // MARK: - Request with response body
       func request<T: Decodable>(
           _ path: String,
           method: String = "GET",
           body: Encodable? = nil,
           requiresAuth: Bool = true
       ) async throws -> T {
           guard let url = URL(string: baseURL + path) else {
               throw APIError.invalidURL
           }
    
           var request = URLRequest(url: url)
           request.httpMethod = method
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
           if requiresAuth {
               guard let token = JWTService.getToken() else {
                   throw APIError.unauthorized
               }
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           }
    
           if let body {
               let encoder = JSONEncoder()
               request.httpBody = try encoder.encode(body)
           }
    
           let (data, response) = try await URLSession.shared.data(for: request)
    
           guard let httpResponse = response as? HTTPURLResponse else {
               throw APIError.unknown(URLError(.badServerResponse))
           }
    
           if httpResponse.statusCode == 401 {
               throw APIError.unauthorized
           }
    
           guard (200...299).contains(httpResponse.statusCode) else {
               let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
               throw APIError.serverError(httpResponse.statusCode, errorResponse?.reason ?? "Something went wrong.")
           }
    
           do {
               let decoder = JSONDecoder()
               decoder.keyDecodingStrategy = .convertFromSnakeCase
               return try decoder.decode(T.self, from: data)
           } catch {
               throw APIError.decodingError(error)
           }
       }
    
       // MARK: - Request with no response body
       func requestEmpty(
           _ path: String,
           method: String = "DELETE",
           body: Encodable? = nil,
           requiresAuth: Bool = true
       ) async throws {
           guard let url = URL(string: baseURL + path) else {
               throw APIError.invalidURL
           }
    
           var request = URLRequest(url: url)
           request.httpMethod = method
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
           if requiresAuth {
               guard let token = JWTService.getToken() else {
                   throw APIError.unauthorized
               }
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           }
    
           if let body {
               let encoder = JSONEncoder()
               request.httpBody = try encoder.encode(body)
           }
    
           let (data, response) = try await URLSession.shared.data(for: request)
    
           guard let httpResponse = response as? HTTPURLResponse else {
               throw APIError.unknown(URLError(.badServerResponse))
           }
    
           if httpResponse.statusCode == 401 {
               throw APIError.unauthorized
           }
    
           guard (200...299).contains(httpResponse.statusCode) else {
               let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
               throw APIError.serverError(httpResponse.statusCode, errorResponse?.reason ?? "Something went wrong.")
           }
       }
   }
    
