//
//  LuckyOutline.swift
//  Together
//
//  A fill, charcoal outline and small hard shadow for any shape (search bar,
//  filter button, category tiles, tab bar).
//

import SwiftUI

struct LuckyOutlineModifier<S: InsettableShape>: ViewModifier {
    let shape: S
    var fill: Color = .cardFill
    var stroke: Color = .charcoal
    var lineWidth: CGFloat = Outline.thick
    var shadowOffset: CGFloat = 3

    func body(content: Content) -> some View {
        content.background {
            ZStack {
                if shadowOffset > 0 {
                    shape.fill(Color.charcoal).offset(x: shadowOffset, y: shadowOffset)
                }
                shape.fill(fill)
                shape.strokeBorder(stroke, lineWidth: lineWidth)
            }
        }
    }
}

extension View {
    func luckyOutline<S: InsettableShape>(
        _ shape: S,
        fill: Color = .cardFill,
        stroke: Color = .charcoal,
        lineWidth: CGFloat = Outline.thick,
        shadowOffset: CGFloat = 3
    ) -> some View {
        modifier(LuckyOutlineModifier(shape: shape, fill: fill, stroke: stroke, lineWidth: lineWidth, shadowOffset: shadowOffset))
    }
}
