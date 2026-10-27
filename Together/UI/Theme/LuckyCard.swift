//
//  LuckyCard.swift
//  Together
//
//  The Lucky Stars card: cream-white fill, thick charcoal outline and a hard
//  offset shadow.
//

import SwiftUI

struct LuckyCardModifier: ViewModifier {
    var radius: CGFloat = Radius.card
    var shadowOffset: CGFloat = Outline.shadowOffset

    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(Color.charcoal)
                        .offset(x: shadowOffset, y: shadowOffset)
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(Color.cardFill)
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(Color.charcoal, lineWidth: Outline.thick)
                }
            }
    }
}

extension View {
    /// Wraps the view in the Lucky Stars card style.
    func luckyCard(radius: CGFloat = Radius.card, shadowOffset: CGFloat = Outline.shadowOffset) -> some View {
        modifier(LuckyCardModifier(radius: radius, shadowOffset: shadowOffset))
    }
}

#Preview {
    Text("Hello")
        .font(.luckyTitle)
        .foregroundStyle(Color.luckyBlue)
        .padding(40)
        .luckyCard()
        .padding()
        .background { Image("LuckyBackground").resizable().scaledToFill().ignoresSafeArea() }
}
