//
//  DelayAppearanceModifier.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//  https://www.photoroom.com/inside-photoroom/improving-loading-experience-in-swiftui
//

import SwiftUI

struct DelayAppearanceModifier: ViewModifier {
    @State var shouldDisplay = false

    let delay: Double

    func body(content: Content) -> some View {
        render(content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.shouldDisplay = true
                }
            }
    }

    @ViewBuilder
    private func render(_ content: Content) -> some View {
        if shouldDisplay {
            content
        } else {
            content
                .hidden()
        }
    }
}

public extension View {
    func delayAppearance(bySeconds seconds: Double) -> some View {
        modifier(DelayAppearanceModifier(delay: seconds))
    }
}
