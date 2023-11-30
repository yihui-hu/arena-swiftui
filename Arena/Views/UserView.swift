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
            UserInfo(userId: userId)
                .padding(.bottom, 4)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            BackButton()
                        }
                    }
                }
                .toolbarBackground(Color("background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}

#Preview {
    UserView(userId: 49570)
}
