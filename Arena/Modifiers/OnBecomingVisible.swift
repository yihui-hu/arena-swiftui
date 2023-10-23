//
//  OnBecomingVisible.swift
//  Arena
//
//  Created by Yihui Hu on 23/10/23.
//  https://stackoverflow.com/questions/60595900/how-to-check-if-a-view-is-displayed-on-the-screen-swift-5-and-swiftui
//

import Foundation
import SwiftUI

public extension View {
    
    func onBecomingVisible(perform action: @escaping () -> Void) -> some View {
        modifier(BecomingVisible(action: action))
    }
}

private struct BecomingVisible: ViewModifier {
    
    @State var action: () -> Void = {} // Initialize with an empty closure
    
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: VisibleKey.self,
                        value: UIScreen.main.bounds.intersects(proxy.frame(in: .global))
                    )
                    .onPreferenceChange(VisibleKey.self) { isVisible in
                        guard isVisible else { return }
                        action() // Call the action closure
                    }
            }
        }
    }
    
    struct VisibleKey: PreferenceKey {
        static var defaultValue: Bool = false
        static func reduce(value: inout Bool, nextValue: () -> Bool) { }
    }
}

