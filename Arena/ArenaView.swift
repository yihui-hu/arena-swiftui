//
//  ContentView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import StatefulTabView
import Pow
import Defaults

struct ArenaView: View {
    @State private var item: Int = 0
    
    var body: some View {        
        StatefulTabView {
            Tab(systemImageName: "heart.fill") {
                PinnedChannelsView()
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
