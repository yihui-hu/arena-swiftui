//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

struct BlockView: View {
    @StateObject var blockData: BlockData
    let blockId: Int
    
    init(blockId: Int) {
        self.blockId = blockId
        _blockData = StateObject(wrappedValue: BlockData(blockId: blockId))
    }
    
    var body: some View {
        NavigationView {
            HStack {
                BlockPreview(blockData: self.blockData.block ?? nil)
            }
            
            if blockData.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
}

#Preview {
    Group {
        BlockView(blockId: 19393606)
//        BlockView(blockId: 24178618)
    }
}

