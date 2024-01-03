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
            RiveViewModel(fileName: colorScheme == .dark ? "channel-pin-dark" : "channel-pin-light").view()
                .overlay(
                    Text("Pin your first channel!")
                        .font(.system(size: 14))
                        .foregroundStyle(Color("surface-tertiary"))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .padding(.top, 208)
                )
        }
        .id(self.colorScheme)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct ConnectFlower: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack() {
            RiveViewModel(fileName: colorScheme == .dark ? "connect-flower-dark" : "connect-flower-light").view()
        }
        .id(self.colorScheme)
    }
}

#Preview {
    // InitialSearch()
    // InitialPinnedChannels()
    ConnectFlower()
}
