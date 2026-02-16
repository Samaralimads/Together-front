//
//  ImportantDate.swift
//  Together
//
//  Created by Samara Lima da Silva on 16/02/2026.
//

import Foundation

struct ImportantDate: Codable, Identifiable  {
    let id: UUID
    var label: String
    var date: Date
}

//add user id
