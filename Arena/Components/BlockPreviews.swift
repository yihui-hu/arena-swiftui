//
//  BlockPreviews.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

// TODO: For displaying PDFs or playing MP3s, do that in separate BlockContentScreen or something

// MARK: BlockPreview for BlockView, since it has highest quality image
struct BlockPreview: View {
    let blockData: Block?
    let fontSize: CGFloat?
    
    var body: some View {
        let previewImgURL = blockData?.image?.large.url ?? nil
        let previewText = blockData?.content ?? ""
        let previewAttachment = blockData?.attachment ?? nil
        // TODO: embeds
        
        VStack {
            if previewImgURL != nil {
                ImagePreview(imageURL: previewImgURL!)
                    .pinchToZoom()
            } else if previewText != "" {
                GeometryReader { geometry in
                    ScrollView {
                        Text(previewText)
                            .foregroundStyle(Color("text-primary"))
                            .font(.system(size: fontSize ?? 16))
                            .frame(minHeight: geometry.size.height)
                    }
                    .scrollIndicators(.hidden)
                    // Prevents parent refreshable from activating. Pray for this colleague's health: https://www.reddit.com/r/SwiftUI/comments/ynxzkd/prevent_refreshable_on_nested_scrollviews/
                    .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
                }
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else {
                Text("No preview available.")
            }
        }
    }
}

// MARK: ChannelViewBlockPreview for ChannelView
struct ChannelViewBlockPreview: View {
    let blockData: Block?
    let fontSize: CGFloat?
    let display: String
    
    var body: some View {
        let previewImgURL = display == "Feed" ? blockData?.image?.display.url : blockData?.image?.thumb.url ?? nil
        let previewText = blockData?.content ?? ""
        let previewAttachment = blockData?.attachment ?? nil
        // TODO: embeds
        
        VStack {
            if previewImgURL != nil {
                ImagePreview(imageURL: previewImgURL!)
            } else if previewText != "" {
                Text(previewText)
                    .padding(16)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
                    .padding(12)
                    .foregroundStyle(Color("text-primary"))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("surface"))
                    )
                    .font(.system(size: fontSize ?? 16))
            } else {
                Text("No preview available.")
            }
        }
    }
}

// MARK: ChannelCardBlockPreview for ChannelCard
struct ChannelCardBlockPreview: View {
    let blockData: Block?
    let fontSize: CGFloat?
    
    var body: some View {
        let previewImgURL = blockData?.image?.thumb.url ?? nil
        let previewText = blockData?.content ?? ""
        let previewAttachment = blockData?.attachment ?? nil
        // TODO: embeds
        
        VStack {
            if previewImgURL != nil {
                ImagePreview(imageURL: previewImgURL!, isChannelCard: true)
                    .frame(height: 132)
            } else if previewText != "" {
                Text(previewText)
                    .padding(16)
                    .frame(width: 132, height: 132)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("surface-tertiary"))
                    )
                    .frame(width: 132, height: 132)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else {
                Text("No preview available.")
                    .frame(width: 132, height: 132)
            }
        }
    }
}
