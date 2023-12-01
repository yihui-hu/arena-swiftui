//
//  ArenaApp.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Modals
import Defaults

extension Defaults.Keys {
    static let pinnedChannels = Key<[Int]>("pinnedChannels", default: [])
    static let accessToken = Key<String>("accessToken", default: "")
    static let username = Key<String>("username", default: "")
    static let userId = Key<Int>("userId", default: 0)
    static let onboardingDone = Key<Bool>("onboardingDone", default: false)
    static let colorScheme = Key<String>("colorScheme", default: "")
}

@main
struct ArenaApp: App {
    @Default(.onboardingDone) var onboardingDone
    @AppStorage("selectedAppearance") var selectedAppearance = 0
    
    var body: some Scene {
        WindowGroup {
            if onboardingDone {
                ModalStackView {
                    ArenaView()
                }
                .contentSaturation(false)
                .contentBackgroundColor(Color("background"))
                .preferredColorScheme(selectedAppearance == 0 ? nil : selectedAppearance == 1 ? .light : .dark)
            } else {
                OnboardingView()
                    .preferredColorScheme(selectedAppearance == 0 ? nil : selectedAppearance == 1 ? .light : .dark)
            }
        }
    }
}
