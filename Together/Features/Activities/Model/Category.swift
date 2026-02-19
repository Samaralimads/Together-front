//
//  Category.swift
//  Together
//
//  Created by Samara Lima da Silva on 17/02/2026.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: UUID
    let name: String
    let imageName: String
}

let mockCategories: [Category] = [
    Category(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        name: "Food & Drinks",
        imageName: "Food&Drinks"
    ),
    Category(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        name: "Nature",
        imageName: "Nature"
    ),
    Category(
        id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
        name: "Creative",
        imageName: "Creative"
    ),
    Category(
        id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
        name: "Wellness",
        imageName: "Wellness"
    )
]
