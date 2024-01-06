//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Pow
import Defaults

struct ArenaView: View {
    @State var tab: Int = 0
    
    var body: some View {
        StatefulTabView(selectedIndex: $tab) {
            Tab(systemImageName: "bookmark.fill") {
                PinnedChannelsView()
            }
            
            Tab(systemImageName: "clock.fill") {
                RabbitHoleView()
            }
            
            Tab(systemImageName: "plus.app.fill") {
                ConnectView()
            }
            
            Tab(systemImageName: "magnifyingglass") {
                SearchView()
            }
            
            Tab(systemImageName: "person.fill") {
                ProfileView(userId: Defaults[.userId])
            }
        }
    }
}

#Preview {
    ArenaView()
}
