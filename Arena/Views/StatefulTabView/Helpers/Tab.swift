//
//  Tab.swift
//
//
//  Created by Nicholas Bellucci on 5/8/20.
//

import SwiftUI
import Defaults

public struct Tab {
    var view: AnyView
    var barItem: UITabBarItem? = nil
    
    internal var prefersLargeTitle: Bool = false
    
    let badgeValue: String?
    
    public init<T>(title: String? = nil,
                   imageName: String,
                   selectedImageName: String? = nil,
                   badgeValue: String? = nil,
                   @ViewBuilder content: @escaping () -> T) where T: View {

        self.badgeValue = badgeValue

        var selectedImage: UIImage?
        if let selectedImageName = selectedImageName {
            selectedImage = UIImage(named: selectedImageName)?.scaledToFit()
        }

        barItem = UITabBarItem(title: title, image: UIImage(named: imageName)?.scaledToFit(), selectedImage: selectedImage)

        self.view = AnyView(content())
    }

    public init<T>(title: String? = nil,
                   systemImageName: String,
                   selectedSystemImageName: String? = nil,
                   badgeValue: String? = nil,
                   @ViewBuilder content: @escaping () -> T) where T: View {

        self.badgeValue = badgeValue

        var selectedImage: UIImage?

        if let selectedSystemImageName = selectedSystemImageName {
            selectedImage = UIImage(systemName: selectedSystemImageName)?.scaledToFit()
        }

        barItem = UITabBarItem(title: title, image: UIImage(systemName: systemImageName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))?.scaledToFit(), selectedImage: selectedImage)

        self.view = AnyView(content())
    }

    public init<T>(title: String? = nil,
                   image: UIImage?,
                   selectedImage: UIImage? = nil,
                   badgeValue: String? = nil,
                   @ViewBuilder content: @escaping () -> T) where T: View {

        self.badgeValue = badgeValue

        barItem = UITabBarItem(title: title, image: image?.scaledToFit(), selectedImage: selectedImage?.scaledToFit())

        self.view = AnyView(content())
    }

}

extension UIImage {
    func scaledToFit(size: CGSize = CGSize(width: 24, height: 24)) -> UIImage {
        let aspectFitSize: CGSize
        let imageSize = self.size
        let aspectWidth = size.width / imageSize.width
        let aspectHeight = size.height / imageSize.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        let topPadding = Defaults[.hasNotch] ? 18.0 : 8.0

        aspectFitSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)

        UIGraphicsBeginImageContextWithOptions(CGSize(width: aspectFitSize.width, height: aspectFitSize.height + topPadding), false, 0.0)

        self.draw(in: CGRect(x: 0, y: topPadding, width: aspectFitSize.width, height: aspectFitSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return scaledImage
    }
}
