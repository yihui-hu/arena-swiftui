//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI

struct ArenaView: View {
    var body: some View {
        TabView {
            ChannelsView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            Text("WE LIVE IN A WORLD OF DATA")
                .tabItem {
                    Label("Data", systemImage: "aqi.medium")
                }
        }
    }
}

#Preview {
    ArenaView()
}
