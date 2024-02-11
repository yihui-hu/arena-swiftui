//
//  DisplayToast.swift
//  Arena
//
//  Created by Yihui Hu on 5/2/24.
//

import Foundation
import Defaults

func displayToast(_ message: String) {
    Defaults[.toastMessage] = message
    Defaults[.showToast] = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        Defaults[.showToast] = false
    }
}
