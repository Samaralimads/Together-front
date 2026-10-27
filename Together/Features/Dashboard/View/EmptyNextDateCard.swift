//
//  EmptyNextDateCard.swift
//  Together
//
//  Created by Samara Lima da Silva on 12/06/2026.
//

import SwiftUI

struct EmptyNextDateCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(.caption2, weight: .bold))
                Text("YOUR NEXT DATE")
                    .font(.system(.caption2, weight: .bold))
                    .kerning(0.5)
            }
            .foregroundStyle(Color.cardFill)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color.luckyBlue.opacity(0.9))
            .clipShape(Capsule())

                Text("No date planned yet")
                    .font(.custom("Gaegu-Bold", size: 22, relativeTo: .title2))
                    .foregroundStyle(Color.charcoal)

            Text("Let's find something fun to do!")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            NavigationLink(destination: ActivityView()) {
                Text("Find an activity →")
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(Color.cardFill)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.luckyBlue.opacity(0.9))
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .luckyCard()
    }
}

#Preview {
    EmptyNextDateCard()
}
