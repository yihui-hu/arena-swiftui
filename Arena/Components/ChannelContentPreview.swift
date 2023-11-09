//
//  ContentPreview.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

// Used in ChannelView
struct ChannelContentPreview: View {
    let block: Block
    let gridItemSize: CGFloat
    let display: String
    
    var body: some View {
        if block.baseClass == "Block" {
            if display == "Table" {
                HStack {
                    HStack(spacing: 8) {
                        ChannelViewBlockPreview(blockData: block, fontSize: 16, display: display)
                            .frame(width: 40, height: 40)
                            .border(Color("surface-secondary"))
                        ChannelContentBlockPreviewMetadata(block: block)
                    }
                    
                    Spacer()
                    
                    Text("\(block.user.fullName)")
                        .font(.system(size: 12))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 8) {
                    ChannelViewBlockPreview(blockData: block, fontSize: 16, display: display)
                        .frame(width: gridItemSize, height: gridItemSize)
                        .border(Color("surface-secondary"))
                    ChannelContentBlockPreviewMetadata(block: block)
                }
            }
        } else {
            // Unnecessary empty text to make it same height... find better solution, .top alignment?
            
            if display == "Table" {
                HStack {
                    HStack(spacing: 8) {
                        ChannelPreview(blockData: block, fontSize: 2)
                            .frame(width: 40, height: 40)
                            .border(Color("arena-orange"))
                        Text("\(block.title)")
                            .font(.system(size: 12))
                            .foregroundStyle(Color("surface-text-secondary"))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text("\(block.user.fullName)")
                        .font(.system(size: 12))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 8) {
                    ChannelPreview(blockData: block, fontSize: 16)
                        .frame(width: gridItemSize, height: gridItemSize)
                        .border(Color("arena-orange"))
                    Text("")
                        .font(.system(size: 12))
                        .foregroundStyle(Color("surface-text-secondary"))
                        .lineLimit(1)
                }
            }
        }
    }
}

struct ChannelContentBlockPreviewMetadata: View {
    let block: Block
    
    var body: some View {
        HStack(alignment: .top) {
            // TODO: General title case, split into components: title first, then any necessary badges, use HStack
            if block.image != nil {
                Text("\(block.image?.filename ?? "")")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("surface-text-secondary"))
                    .lineLimit(1)
                // Handles URL
            } else if block.contentClass == "url" {
                Text("\(block.title != "" ? block.title : block.source?.url ?? "")")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("surface-text-secondary"))
                    .lineLimit(1)
                Image(systemName: "link")
            } else {
                Text("")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("surface-text-secondary"))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 12)
    }
}
