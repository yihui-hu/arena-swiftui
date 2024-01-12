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
        GeometryReader { geometry in
            StatefulTabView(selectedIndex: $tab) {
                Tab(systemImageName: "bookmark.fill") {
                    PinnedChannelsView()
                        .onAppear {
                            Defaults[.widgetTapped] = false
                        }
                }
                
                Tab(systemImageName: "magnifyingglass") {
                    SearchView()
                        .onAppear {
                            Defaults[.widgetTapped] = false
                        }
                }
                
                Tab(systemImageName: "plus.app.fill") {
                    ConnectView()
                        .onAppear {
                            Defaults[.widgetTapped] = false
                        }
                }
                
                Tab(systemImageName: "clock.fill") {
                    RabbitHoleView()
                        .onAppear {
                            Defaults[.widgetTapped] = false
                        }
                }
                
                Tab(systemImageName: "person.fill") {
                    ProfileView(userId: Defaults[.userId])
                        .onAppear {
                            Defaults[.widgetTapped] = false
                        }
                }
            }
            .onAppear {
                let topInset = geometry.safeAreaInsets.top
                if topInset >= 44 {
                    Defaults[.hasNotch] = true
                } else {
                    Defaults[.hasNotch] = false
                }
            }
        }
    }
}

#Preview {
    ArenaView()
}
