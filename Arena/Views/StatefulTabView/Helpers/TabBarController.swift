//
//  TabBarController.swift
//
//
//  Created by Nicholas Bellucci on 5/8/20.
//  Modified by Yihui Hu on 11/12/23.

import SwiftUI

public enum TabBarBackgroundConfiguration {
    case `default`
    case opaque
    case transparent
}

struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    var tabBarItems: [Tab]
    
    var barTintColor: UIColor?
    var unselectedItemTintColor: UIColor?
    var backgroundColor: UIColor?
    var tabBarConfiguration: TabBarBackgroundConfiguration?
    
    @Binding var selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = selectedIndex
        
        configure(tabBarController.tabBar)
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
        
        tabBarItems.forEach { tab in
            guard let index = tabBarItems.firstIndex(where: { $0.barItem == tab.barItem }), let controllers = tabBarController.viewControllers else { return }
            
            if controllers.indices.contains(index) {
                controllers[index].tabBarItem.badgeValue = tab.badgeValue
            }
        }
    }
    
    func makeCoordinator() -> TabBarCoordinator {
        TabBarCoordinator(self)
    }
}

private extension TabBarController {
    func configure(_ tabBar: UITabBar) {
        let appearance = tabBar.standardAppearance.copy()

        appearance.configureWithTransparentBackground()
        
        if let barTintColor = barTintColor {
            tabBar.tintColor = barTintColor
        }
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        if let unselectedItemTintColor = unselectedItemTintColor {
            if #available(iOS 13.0, *) {
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectedItemTintColor]
                appearance.stackedLayoutAppearance.normal.iconColor = unselectedItemTintColor
            } else {
                tabBar.unselectedItemTintColor = unselectedItemTintColor
            }
        }
        
        let horizontalPadding: CGFloat = 12.0 // Adjust this value as needed
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                switch index {
                case 0:
                    item.imageInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: -horizontalPadding)
                case 1:
                    item.imageInsets = UIEdgeInsets(top: 0, left: horizontalPadding * 0.5, bottom: 0, right: -horizontalPadding * 0.5)
                case 2:
                    item.imageInsets = UIEdgeInsets(top: 0, left: -horizontalPadding, bottom: 0, right: -horizontalPadding)
                case 3:
                    item.imageInsets = UIEdgeInsets(top: 0, left: -horizontalPadding * 0.5, bottom: 0, right: horizontalPadding * 0.5)
                case 4:
                    item.imageInsets = UIEdgeInsets(top: 0, left: -horizontalPadding, bottom: 0, right: horizontalPadding)
                default:
                    item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
            }
        }
        
        tabBar.standardAppearance = appearance
    }
    
    func navigationController(in viewController: UIViewController) -> UINavigationController? {
        var controller: UINavigationController?
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        viewController.children.forEach {
            if let navigationController = $0 as? UINavigationController {
                controller = navigationController
            } else {
                controller = navigationController(in: $0)
            }
        }
        
        return controller
    }
}
