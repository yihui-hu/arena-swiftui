//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import NavigationTransitions
import TabBarModule


struct ArenaView: View {
    @State private var item: Int = 0
    
    var body: some View {
        TabBar(selection: $item) {
            ChannelsView()
                .tabItem(0) {
                    Image(systemName: "heart.fill")
                        .padding(.top, 4)
                        .imageScale(.large)
                        .foregroundColor(item == 0 ? Color.black : Color.gray)
                }
            
            Text("WE LIVE IN A WORLD OF DATA")
                .tabItem(1) {
                    Image(systemName: "aqi.medium")
                        .padding(.top, 4)
                        .imageScale(.large)
                        .foregroundColor(item == 1 ? Color.black : Color.gray)
                }
        }
        .tabBarFill(.thinMaterial)
        //        .tabBarFill(.regularMaterial)
        //        .tabBarMargins(.vertical, 8)
        //        .tabBarPadding(.vertical, 8)
        //        .tabBarPadding(.horizontal, 60)
        //        .tabBarShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        //        .tabBarShadow(radius: 1, y: 1)
    }
}

#Preview {
    ArenaView()
}
