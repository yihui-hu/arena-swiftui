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
        HStack {
            let firstImage = blockData.block?.image?.large.url ?? ""
            
            AsyncImage(url: URL(string: firstImage)) { phase in
                if let image = phase.image {
                    // if the image is valid
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    // placeholder / error image
                    Image(systemName: "photo")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.gray)
                }
            }.frame(alignment: .center)
        }
        
        if blockData.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}

#Preview {
    BlockView(blockId: 19393606)
}

