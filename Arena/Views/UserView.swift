//
//  UserView.swift
//  Arena
//
//  Created by Yihui Hu on 11/11/23.
//

import SwiftUI

struct UserView: View {
    let userId: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ProfileView(userId: userId)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    UserView(userId: 49570)
}
