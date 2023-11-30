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
}

@main
struct ArenaApp: App {
    @Default(.onboardingDone) var onboardingDone
    
    var body: some Scene {
        WindowGroup {
            if onboardingDone {
                ModalStackView {
                    ArenaView()
                }
                .contentSaturation(false)
                .contentBackgroundColor(Color("background"))
            } else {
                OnboardingView()
            }
        }
    }
}
