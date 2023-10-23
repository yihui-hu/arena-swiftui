//
//  DataView.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI

struct DataView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                Text("WE LIVE IN A WORLD OF DATA")
            }
            .frame(maxWidth: .infinity)
            .background(Color("background"))
        }
    }
}

#Preview {
    DataView()
}
