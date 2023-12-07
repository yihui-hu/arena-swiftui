//
//  ScaleButtonStyle.swift
//  Arena
//
//  Created by Yihui Hu on 6/12/23.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}
