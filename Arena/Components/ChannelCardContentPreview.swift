//
//  ChannelsContentPreview.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

struct ChannelsContentPreview: View {
    let block: Block
    
    var body: some View {
        VStack {
            if block.baseClass == "Block" {
                ChannelsCardBlockPreview(blockData: block, fontSize: 14)
                    .frame(width: 132, height: 132)
            } else {
                ChannelPreview(blockData: block, fontSize: 14)
                    .frame(width: 132, height: 132)
                    .background(Color("surface-secondary"))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
