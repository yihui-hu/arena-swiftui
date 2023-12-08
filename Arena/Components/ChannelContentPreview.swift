//
//  ContentPreview.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

// Used in ChannelView
import SwiftUI
import BetterSafariView

struct ChannelContentPreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String
    @Binding var presentingConnectSheet: Bool
    
    var body: some View {
        if block.baseClass == "Block" {
            if display == "Table" {
                BlockTablePreview(block: block, channelData: channelData, channelSlug: channelSlug, display: display, presentingConnectSheet: $presentingConnectSheet)
            } else {
                BlockGridPreview(block: block, channelData: channelData, channelSlug: channelSlug, gridItemSize: gridItemSize, display: display, presentingConnectSheet: $presentingConnectSheet)
            }
        } else {
            // TODO: Added channelSlug here... might want to do something interesting in the future (preview blocks in context menu!). If not, clean up
            if display == "Table" {
                ChannelTablePreview(block: block, channelSlug: channelSlug, display: display, presentingConnectSheet: $presentingConnectSheet)
            } else {
                ChannelGridPreview(block: block, channelSlug: channelSlug, gridItemSize: gridItemSize, display: display, presentingConnectSheet: $presentingConnectSheet)
            }
        }
    }
}

struct BlockTablePreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let display: String
    @State private var presentingSafariView = false
    @Binding var presentingConnectSheet: Bool
    
    var body: some View {
        HStack {
            ChannelViewBlockPreview(blockData: block, fontSize: 8, display: "Table", isContextMenuPreview: false)
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
            BlockContextMenu(block: block, showViewOption: true, channelData: channelData, channelSlug: channelSlug, presentingSafariView: $presentingSafariView)
        } preview: {
            BlockContextMenuPreview(block: block)
        }
        .safariView(isPresented: $presentingSafariView) {
            SafariView(
                url: URL(string: block.source?.url ?? "https://are.na/source/\(block.id)")!,
                configuration: SafariView.Configuration(
                    entersReaderIfAvailable: false,
                    barCollapsingEnabled: true
                )
            )
            .preferredBarAccentColor(.clear)
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
    }
}

struct ChannelTablePreview: View {
    let block: Block
    let channelSlug: String
    let display: String
    @Binding var presentingConnectSheet: Bool
    
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
        .background(Color("background"))
        .contextMenu {
            ChannelContextMenu(channel: block, showViewOption: true)
        } preview: {
            ChannelContextMenuPreview(channel: block)
        }
    }
}

struct BlockGridPreview: View {
    let block: Block
    let channelData: ChannelData
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String
    @State private var presentingSafariView = false
    @Binding var presentingConnectSheet: Bool
    
    var body: some View {
        let _ = Self._printChanges()
        VStack(spacing: 8) {
            ChannelViewBlockPreview(blockData: block, fontSize: display == "Grid" ? 12 : display == "Feed" ? 16 : 10, display: display, isContextMenuPreview: false)
                .frame(width: gridItemSize, height: gridItemSize)
                .background(Color("background"))
                .contextMenu {
                    BlockContextMenu(block: block, showViewOption: true, channelData: channelData, channelSlug: channelSlug, presentingSafariView: $presentingSafariView)
                } preview: {
                    BlockContextMenuPreview(block: block)
                }
            
            if display != "Large Grid" {
                ContentPreviewMetadata(block: block, display: display)
                    .padding(.horizontal, 12)
            }
        }
        .safariView(isPresented: $presentingSafariView) {
            SafariView(
                url: URL(string: block.source?.url ?? "https://are.na/source/\(block.id)")!,
                configuration: SafariView.Configuration(
                    entersReaderIfAvailable: false,
                    barCollapsingEnabled: true
                )
            )
            .preferredBarAccentColor(.clear)
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
    }
}

struct ChannelGridPreview: View {
    let block: Block
    let channelSlug: String
    let gridItemSize: CGFloat
    let display: String
    @Binding var presentingConnectSheet: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ChannelPreview(blockData: block, fontSize: display != "Large Grid" ? 16 : 12, display: display)
                .frame(width: gridItemSize, height: gridItemSize)
                .border(Color("arena-orange"))
                .background(Color("background"))
                .contextMenu {
                    ChannelContextMenu(channel: block, showViewOption: true)
                } preview: {
                    ChannelContextMenuPreview(channel: block)
                }
            
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
