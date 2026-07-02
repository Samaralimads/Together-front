//
//  EmptyNextDateCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/06/2026.
//

import SwiftUI

struct EmptyNextDateCard: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("No date planned yet")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
            Text("🤔")
                .font(.system(size: 30))
            Text("Let's find something fun to do!")
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(.secondary)
            NavigationLink(destination: ActivityView()) {
                Text("Find an activity")
            }
            .modifier(AccentButtonModifier())
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.branco))
    }
}
