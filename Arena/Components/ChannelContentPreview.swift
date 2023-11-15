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
    let gridItemSize: CGFloat
    let display: String
    
    var body: some View {
        if block.baseClass == "Block" {
            if display == "Table" {
                BlockTablePreview(block: block, display: display)
            } else {
                BlockGridPreview(block: block, gridItemSize: gridItemSize, display: display)
            }
        } else {
            if display == "Table" {
                ChannelTablePreview(block: block, display: display)
            } else {
                ChannelGridPreview(block: block, gridItemSize: gridItemSize, display: display)
            }
        }
    }
}

struct BlockTablePreview: View {
    let block: Block
    let display: String
    
    var body: some View {
        HStack {
            ChannelViewBlockPreview(blockData: block, fontSize: 8, display: "Table")
                .frame(width: 64, height: 64)
                .border(Color("surface-secondary"))
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
            
            Button {
                // Do something
            } label: {
                Label("View", systemImage: "eye")
            }
        } preview: {
            ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Feed") // TODO: FIX!!!
        }
    }
}

struct ChannelTablePreview: View {
    let block: Block
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
    let gridItemSize: CGFloat
    let display: String
    
    var body: some View {
        VStack(spacing: 8) {
            ChannelViewBlockPreview(blockData: block, fontSize: display != "Large Grid" ? 12 : 10, display: display)
                .frame(width: gridItemSize, height: gridItemSize)
                .background(Color("background"))
                .border(Color("surface"))
                .contextMenu {
                    Button {
                        // Do something
                    } label: {
                        Label("Connect", systemImage: "arrow.right")
                    }
                    
                    Button {
                        // Do something
                    } label: {
                        Label("View", systemImage: "eye")
                    }
                } preview: {
                    ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Feed")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        HStack(alignment: .top, spacing: 4) {
            // URL case
            if block.contentClass == "Link" {
                Text("\(block.title != "" ? block.title : block.source?.url ?? "")")
                Image(systemName: "link")
                    .imageScale(.small)
            // Default to title
            } else if block.title != "" {
                Text("\(block.title != "" ? block.title : "")")
            // Image block
            } else if block.image != nil {
                Text("\(block.image?.filename ?? "")")
            // Content block
            } else if block.content != nil {
                Text("\(display == "Table" ? block.content ?? "" : "")")
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
