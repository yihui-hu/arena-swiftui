//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

struct BlockView: View {
    let blockData: Block?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                BlockPreview(blockData: self.blockData ?? nil)
                Text("\(blockData?.title ?? "")")
                Text("\(blockData?.createdAt ?? "")")
                Text("Connected by \(blockData?.connectedByUsername ?? "unknown")")
            }
        }
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
    }
}

//#Preview {
//    NavigationView {
//        BlockView(blockData: BlockData(blockId: 24185173).block ?? nil)
//    }
//}
//
