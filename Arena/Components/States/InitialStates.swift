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
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
                .fontWeight(.black)
                .foregroundStyle(Color("surface-text-secondary"))
                .frame(width: 52, height: 52)
                .background(Color("surface"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Text("You haven't searched anything yet...")
                .font(.system(size: 14))
                .foregroundStyle(Color("surface-tertiary"))
                .fontDesign(.rounded)
                .fontWeight(.semibold)
        }
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
                        .fontWeight(.semibold)
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

struct ConnectFlower: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack() {
            RiveViewModel(fileName: colorScheme == .dark ? "connect-flower-dark" : "connect-flower-light").view()
                .frame(height: 400)
                .clipShape(CFShape())
        }
        .id(self.colorScheme)
    }
}

// Custom clip shape for Pinned Channels Rive animation
struct CFShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = rect.width
        let height: CGFloat = 480
        
        let xOffset = (rect.width - width) / 2
        let yOffset = (rect.height - height) / 2 - 100
        
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
    // InitialPinnedChannels()
    ConnectFlower()
}
