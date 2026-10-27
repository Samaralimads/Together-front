//
//  Spacing.swift
//  Together
//
//  Spacing, radius and outline tokens shared by every screen.
//

import SwiftUI

enum Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

enum Radius {
    /// Cards and sheets.
    static let card: CGFloat = 30
    /// Small tiles (code boxes, stat tiles, category tiles).
    static let tile: CGFloat = 16
}

enum Outline {
    /// Charcoal outline of cards, buttons and the tab bar.
    static let thick: CGFloat = 2
    /// Grey outline of fields and code boxes.
    static let field: CGFloat = 1.5
    /// Offset of the hard charcoal shadow behind cards and buttons.
    static let shadowOffset: CGFloat = 5
}
