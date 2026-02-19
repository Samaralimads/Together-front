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

let mockActivities: [Activity] = [
    Activity(
        id: UUID(),
        title: "Brunch at a Local Café",
        description: "Enjoy a slow Sunday morning with pastries and coffee in a cozy café. Enjoy a slow Sunday morning with pastries and coffee in a cozy café.",
        budget: "€€",
        duration: 120,
        isIndoor: true,
        categoryId: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    ),
    Activity(
        id: UUID(),
        title: "Sunset Picnic",
        description: "Pack a blanket and watch the sky change colors together.",
        budget: "€",
        duration: 150,
        isIndoor: false,
        categoryId: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    ),
    Activity(
        id: UUID(),
        title: "Pottery Workshop",
        description: "Create something meaningful side by side.",
        budget: "€€€",
        duration: 180,
        isIndoor: true,
        categoryId: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    )
]

