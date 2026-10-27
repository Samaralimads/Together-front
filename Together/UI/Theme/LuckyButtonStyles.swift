//
//  LuckyButtonStyles.swift
//  Together
//
//  Primary, secondary and destructive button styles.
//

import SwiftUI

/// Solid charcoal pill with cream-white text.
struct LuckyPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.luckyButton)
            .foregroundStyle(Color.cardFill)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Capsule().fill(Color.charcoal))
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.7)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Cream-white pill with a charcoal outline.
struct LuckySecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.luckyButton)
            .foregroundStyle(Color.charcoal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Capsule().fill(Color.cardFill))
            .overlay(Capsule().strokeBorder(Color.charcoal, lineWidth: Outline.thick))
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Sign out, Delete account, Unpair partner: red text on a charcoal-outlined pill.
struct LuckyDestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.luckyBodyStrong)
            .foregroundStyle(Color.destructiveRed)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Capsule().fill(Color.cardFill))
            .overlay(Capsule().strokeBorder(Color.charcoal, lineWidth: 1.5))
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == LuckyPrimaryButtonStyle {
    static var luckyPrimary: LuckyPrimaryButtonStyle { .init() }
}

extension ButtonStyle where Self == LuckySecondaryButtonStyle {
    static var luckySecondary: LuckySecondaryButtonStyle { .init() }
}

extension ButtonStyle where Self == LuckyDestructiveButtonStyle {
    static var luckyDestructive: LuckyDestructiveButtonStyle { .init() }
}

#Preview {
    VStack(spacing: 16) {
        Button("Create Account") {}.buttonStyle(.luckyPrimary)
        Button("Log In") {}.buttonStyle(.luckySecondary)
        Button("Sign out") {}.buttonStyle(.luckyDestructive)
        Button("Disabled") {}.buttonStyle(.luckyPrimary).disabled(true)
    }
    .padding()
    .background { Image("LuckyBackground").resizable().scaledToFill().ignoresSafeArea() }
}
