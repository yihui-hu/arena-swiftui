//
//  SingleBlockView.swift
//  Arena
//
//  Created by Yihui Hu on 21/10/23.
//

import SwiftUI

struct SingleBlockView: View {
    let blockId: Int
    @Environment(\.dismiss) private var dismiss
    
    init(blockId: Int) {
        self.blockId = blockId
    }
    
    var body: some View {
        VStack() {
            Text("\(blockId)")
                .foregroundColor(Color("text-primary"))
        }
        .background(Color("background"))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
