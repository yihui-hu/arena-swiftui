//
//  ContentPreview.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

// Used in ChannelView
import SwiftUI

struct ChannelContentPreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String
    
    var body: some View {
        if block.baseClass == "Block" {
            if display == "Table" {
                BlockTablePreview(block: block, channelData: channelData, channelSlug: channelSlug, display: display)
            } else {
                BlockGridPreview(block: block, channelData: channelData, channelSlug: channelSlug, gridItemSize: gridItemSize, display: display)
            }
        } else {
            // TODO: Added channelSlug here... might want to do something interesting in the future (preview blocks in context menu!). If not, clean up
            if display == "Table" {
                ChannelTablePreview(block: block, channelSlug: channelSlug, display: display)
            } else {
                ChannelGridPreview(block: block, channelSlug: channelSlug, gridItemSize: gridItemSize, display: display)
            }
        }
    }
}

struct BlockTablePreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let display: String
    
    var body: some View {
        HStack {
            ChannelViewBlockPreview(blockData: block, fontSize: 8, display: "Table")
                .frame(width: 64, height: 64)
            ContentPreviewMetadata(block: block, display: display)
            
            Spacer()
            
            NavigationLink(destination: UserView(userId: block.user.id)) {
                Text("\(block.user.fullName)")
                    .font(.system(size: 12))
                    .frame(width: 72, alignment: .leading)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("background"))
        .contextMenu {
            Button {
                // Do something
            } label: {
                Label("Connect", systemImage: "arrow.right")
            }
            
            NavigationLink(destination: BlockView(blockData: block, channelData: channelData, channelSlug: channelSlug)) {
                Label("View", systemImage: "eye")
            }
        } preview: {
            let img = block.image
            if img != nil {
                ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Feed")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ChannelViewBlockPreview(blockData: block, fontSize: 18, display: "Feed")
                    .padding(32)
                    .frame(width: 400, height: 400)
            }
        }
    }
}

struct ChannelTablePreview: View {
    let block: Block
    let channelSlug: String
    let display: String
    
    var body: some View {
        HStack {
            ChannelPreview(blockData: block, fontSize: 8, display: display)
                .frame(width: 64, height: 64)
                .border(Color("arena-orange"))
            
            Text("\(block.title)")
                .font(.system(size: 12))
                .foregroundStyle(Color("arena-orange"))
                .lineLimit(1)
            
            Spacer()
            
            NavigationLink(destination: UserView(userId: block.user.id)) {
                Text("\(block.user.fullName)")
                    .font(.system(size: 12))
                    .frame(width: 72, alignment: .leading)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BlockGridPreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String

    var body: some View {
        VStack(spacing: 8) {
            ChannelViewBlockPreview(blockData: block, fontSize: display == "Grid" ? 12 : display == "Feed" ? 16 : 10, display: display)
                .frame(width: gridItemSize, height: gridItemSize)
                .background(Color("background"))
                .contextMenu {
                    Button {
                        // Do something
                    } label: {
                        Label("Connect", systemImage: "arrow.right")
                    }
                    
                    NavigationLink(destination: BlockView(blockData: block, channelData: channelData, channelSlug: channelSlug)) {
                        Label("View", systemImage: "eye")
                    }
                } preview: {
                    let img = block.image
                    if img != nil {
                        ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Feed")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ChannelViewBlockPreview(blockData: block, fontSize: 18, display: "Feed")
                            .padding(32)
                            .frame(width: 400, height: 400)
                    }
                }
            
            if display != "Large Grid" {
                ContentPreviewMetadata(block: block, display: display)
                    .padding(.horizontal, 12)
            }
        }
    }
}

struct ChannelGridPreview: View {
    let block: Block
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String
    
    var body: some View {
        VStack(spacing: 8) {
            ChannelPreview(blockData: block, fontSize: display != "Large Grid" ? 16 : 12, display: display)
                .frame(width: gridItemSize, height: gridItemSize)
                .border(Color("arena-orange"))
            
            if display != "Large Grid" {
                ContentPreviewMetadata(block: block, display: display)
            }
        }
    }
}

struct ContentPreviewMetadata: View {
    let block: Block
    let display: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            // URL case
            if block.contentClass == "Link" {
                Text("\(block.title != "" ? block.title : block.source?.url ?? "")")
                Image(systemName: "link")
                    .imageScale(.small)
                // Attachment case
            } else if block.attachment != nil {
                Text("\(block.title != "" ? block.title : block.attachment?.filename ?? "")")
                Text("\(block.attachment?.fileExtension ?? "file")")
                    .font(.system(size: 12))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color("surface"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                // Image block
            } else if block.image != nil {
                Text("\(block.title != "" ? block.title : block.image?.filename ?? "")")
                // Text block
            } else if block.content != nil {
                Text("\(display == "Table" ? block.content ?? "" : "")")
                // Default to title
            } else if block.title != "" {
                Text("\(block.title != "" ? block.title : "")")
                // NIL case
            } else {
                Text("\(display == "Table" ? "–" : "")")
            }
        }
        .font(.system(size: 12))
        .foregroundStyle(Color("surface-text-secondary"))
        .lineLimit(display == "Table" ? 3 : 1)
        .multilineTextAlignment(display == "Table" ? .leading : .center)
    }
}
