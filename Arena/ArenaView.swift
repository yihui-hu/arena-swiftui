//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import TabBarModule

struct ArenaView: View {
    @State private var item: Int = 0
    
    var body: some View {
        TabBar(selection: $item) {
            ChannelsView()
                .tabItem(0) {
                    TabItem(iconName: "heart.fill", tabIndex: 0, item: $item)
                }
            
            SearchView()
                .tabItem(1) {
                    TabItem(iconName: "magnifyingglass", tabIndex: 1, item: $item)
                }
            
            SearchView()
                .tabItem(2) {
                    TabItem(iconName: "safari.fill", tabIndex: 2, item: $item)
                }
            
            DataView()
                .tabItem(3) {
                    TabItem(iconName: "clock.fill", tabIndex: 3, item: $item)
                }
            
            ProfileView()
                .tabItem(4) {
                    TabItem(iconName: "person.fill", tabIndex: 4, item: $item)
                }
        }
        .tabBarFill(.regularMaterial)
        .tabBarMargins(.bottom, 8)
        .tabBarMargins(.top, 16)
        .tabBarMargins(.horizontal, 20)
        .tabBarShadow(color: Color("surface-text-secondary"), radius: 1, y: 0)
    }
}

struct TabItem: View {
    let iconName: String
    let tabIndex: Int
    @Binding var item: Int
    
    var body: some View {
        Image(systemName: iconName)
            .imageScale(.large)
            .foregroundColor(item == tabIndex ? Color("tab-selected") : Color("tab-unselected"))
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    ArenaView()
}
