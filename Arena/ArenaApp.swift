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
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .textPrimary
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.textPrimary.withAlphaComponent(0.2)
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
                    .toast(isPresenting: $showToast, offsetY: 64) {
                        AlertToast(displayMode: .hud, type: .regular, title: toastMessage)
                    }
            } else {
                OnboardingView()
                    .preferredColorScheme(selectedAppearance == 0 ? nil : selectedAppearance == 1 ? .light : .dark)
            }
        }
    }
}
