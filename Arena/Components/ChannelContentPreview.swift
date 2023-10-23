//
//  ContentPreview.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

struct ContentPreview: View {
    let block: Block
    let gridItemSize: CGFloat
    
    var body: some View {
        if block.baseClass == "Block" {
            BlockPreview(blockData: block)
                .frame(width: gridItemSize, height: gridItemSize)
                .border(Color("surface-secondary"))
        } else {
            Text("\(block.title) by \(block.user.username)")
                .frame(width: gridItemSize, height: gridItemSize)
                .border(Color.orange)
        }
    }
}
