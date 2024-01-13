//
//  ArenaApp.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Defaults
import AlertToast
import BetterSafariView

extension Defaults.Keys {
    // User specific data
    static let pinnedChannels = Key<[Int]>("pinnedChannels", default: [])
    static let pinnedChannelsChanged = Key<Bool>("pinnedChannelsChanged", default: false)
    static let accessToken = Key<String>("accessToken", default: "")
    static let username = Key<String>("username", default: "")
    static let userId = Key<Int>("userId", default: 0)
    static let onboardingDone = Key<Bool>("onboardingDone", default: false)
    
    // Global data
    static let connectSheetOpen = Key<Bool>("connectSheetOpen", default: false)
    static let connectItemId = Key<Int>("connectItemId", default: 0)
    static let connectItemType = Key<String>("connectItemType", default: "Block")
    static let connectedItem = Key<Bool>("connectedItem", default: false)
    static let showToast = Key<Bool>("showToast", default: false)
    static let toastMessage = Key<String>("toastMessage", default: "")
    static let safariViewOpen = Key<Bool>("safariViewOpen", default: false)
    static let safariViewURL = Key<String>("safariViewURL", default: "https://arena-ios-app.vercel.app")
    static let hasNotch = Key<Bool>("hasNotch", default: true)
    static let appIconAlert = Key<Bool>("appIconAlert", default: false)
    static let widgetTapped = Key<Bool>("widgetTapped", default: false)
    static let widgetBlockId = Key<Int>("widgetBlockId", default: 0)
    
    // Rabbit hole
    static let rabbitHole = Key<[RabbitHoleItem]>("rabbitHole", default: [])
}

@main
struct ArenaApp: App {
    @Default(.onboardingDone) var onboardingDone
    @Default(.connectSheetOpen) var connectSheetOpen
    @Default(.showToast) var showToast
    @Default(.toastMessage) var toastMessage
    @Default(.safariViewOpen) var safariViewOpen
    @Default(.safariViewURL) var safariViewURL
    @Default(.rabbitHole) var rabbitHole
    @Default(.widgetTapped) var widgetTapped
    @Default(.widgetBlockId) var widgetBlockId
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    @State private var channelSlug = ""
    @State private var navigateToChannelView = false
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .textPrimary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.textPrimary.withAlphaComponent(0.2)
        self.connectSheetOpen = false
        self.safariViewOpen = false
    }
    
    var body: some Scene {
        WindowGroup {
            if onboardingDone {
                ArenaView()
                    .preferredColorScheme(selectedAppearance == 0 ? nil : selectedAppearance == 1 ? .light : .dark)
                    .sheet(isPresented: $connectSheetOpen) {
                        ConnectExistingView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .presentationDetents([.fraction(0.64), .large])
                            .presentationBackground(Color("sheet"))
                            .presentationContentInteraction(.scrolls)
                            .presentationCornerRadius(32)
                            .contentMargins(16)
                    }
                    .safariView(isPresented: $safariViewOpen) {
                        SafariView(
                            url: URL(string: safariViewURL)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.clear)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    .toast(isPresenting: $showToast, offsetY: Defaults[.hasNotch] ? 64 : 32) {
                        AlertToast(displayMode: .hud, type: .regular, title: toastMessage)
                    }
                    .onOpenURL { url in
                        widgetBlockId = parseDeeplink(url)
                        print(widgetBlockId)
                        if widgetBlockId != 0 {
                            widgetTapped = true
                        }
                    }
            } else {
                OnboardingView()
                    .preferredColorScheme(selectedAppearance == 0 ? nil : selectedAppearance == 1 ? .light : .dark)
                    .safariView(isPresented: $safariViewOpen) {
                        SafariView(
                            url: URL(string: safariViewURL)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.clear)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
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

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}

private func parseDeeplink(_ url: URL) -> Int {
    guard url.scheme == "are-na" else {
        print("Invalid url scheme")
        return 0
    }
    
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        print("Invalid URL")
        return 0
    }
    
    guard let blockId = components.queryItems?.first(where: { $0.name == "blockId" })?.value else {
        print("Block id not found")
        return 0
    }
    
    return Int(blockId) ?? 0
}
