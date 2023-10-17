//
//  HomeView.swift
//  Arena
//
//  Created by Yihui Hu on 17/10/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            FavouritesView()
            ChannelsView()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    HomeView()
}
