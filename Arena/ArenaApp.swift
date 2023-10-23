//
//  ArenaApp.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Modals

@main
struct ArenaApp: App {
    var body: some Scene {
        WindowGroup {
            ModalStackView {
                ArenaView()
            }
        }
    }
}
