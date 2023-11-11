//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import TabBarModule
import Pow
import Defaults

extension Defaults.Keys {
    static let pinnedChannels = Key<[Int]>("pinnedChannels", default: [])
}

struct ArenaView: View {
    @State private var item: Int = 0
    
    var body: some View {
        TabBar(selection: $item) {
            PinnedChannelsView()
                .tabItem(0) {
                    TabItem(iconName: "heart.fill", tabIndex: 0, item: $item)
                }
            
            SearchView()
                .tabItem(1) {
                    TabItem(iconName: "magnifyingglass", tabIndex: 1, item: $item)
                }
            
            ExploreView()
                .tabItem(2) {
                    TabItem(iconName: "safari.fill", tabIndex: 2, item: $item)
                }
            
            //            DataView()
            //                .tabItem(3) {
            //                    TabItem(iconName: "clock.fill", tabIndex: 3, item: $item)
            //                }
            
            ProfileView(userId: 49570) // TODO: Replace userId with storage one?
                .tabItem(3) {
                    TabItem(iconName: "person.fill", tabIndex: 3, item: $item)
                }
        }
        .tabBarFill(Color("background"))
        .tabBarMargins(.bottom, 8)
        .tabBarMargins(.top, 16)
        .tabBarMargins(.horizontal, 20)
        //        .tabBarShadow(color: Color("surface-text-secondary"), radius: 1, y: 0)
    }
}

struct TabItem: View {
    
    let iconName: String
    let tabIndex: Int
    @Binding var item: Int
    
    @State private var pressed = false
    
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

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

#Preview {
    ArenaView()
}
