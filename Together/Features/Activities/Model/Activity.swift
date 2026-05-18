//
//  Activity.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import Foundation

struct Activity: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let budget: String
    let duration: Int
    let isIndoor: Bool
    let categoryId: UUID
}

