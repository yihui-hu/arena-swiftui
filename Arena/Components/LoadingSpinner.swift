//
//  LoadingSpinner.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(height: 64)
    }
}

#Preview {
    LoadingSpinner()
}
