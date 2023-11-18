//
//  InitialStates.swift
//  Arena
//
//  Created by Yihui Hu on 16/11/23.
//

import SwiftUI
import RiveRuntime

struct InitialSearch: View {
    var body: some View {
        // TODO: Emulate Family's browser search empty state
        Text("You haven't searched anything yet...")
            .font(.system(size: 14))
            .foregroundStyle(Color("surface-tertiary"))
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.top, 24)
    }
}

struct InitialPinnedChannels: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack() {
            RiveViewModel(fileName: colorScheme == .dark ? "pinned-channels-initial-dark" : "pinned-channels-initial-light").view()
                .frame(height: 400)
                .clipShape(IPCShape())
                .overlay(
                    Text("Pin your first channel!")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("surface-tertiary"))
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .padding(.top, 220)
                )
        }
        .id(self.colorScheme)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// Custom clip shape for Pinned Channels Rive animation
struct IPCShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = rect.width
        let height: CGFloat = 270
        
        let xOffset = (rect.width - width) / 2
        let yOffset = (rect.height - height) / 2 - 44
        
        var path = Path()
        path.move(to: CGPoint(x: xOffset, y: yOffset))
        path.addLine(to: CGPoint(x: xOffset + width, y: yOffset))
        path.addLine(to: CGPoint(x: xOffset + width, y: yOffset + height))
        path.addLine(to: CGPoint(x: xOffset, y: yOffset + height))
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    // InitialSearch()
    InitialPinnedChannels()
}
