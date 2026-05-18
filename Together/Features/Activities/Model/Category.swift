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
