//
//  BackButton.swift
//  Arena
//
//  Created by Yihui Hu on 15/11/23.
//

import SwiftUI

struct BackButton: View {
    var body: some View {
        Image(systemName: "chevron.backward")
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .foregroundStyle(Color("text-primary"))
    }
}

#Preview {
    BackButton()
}
