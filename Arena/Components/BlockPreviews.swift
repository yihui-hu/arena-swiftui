//
//  BlockPreviews.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import BetterSafariView

// TODO: For displaying PDFs or playing MP3s, do that in separate BlockContentScreen or something

// MARK: BlockPreview for BlockView, since it has highest quality image
struct BlockPreview: View {
    let blockData: Block?
    let fontSize: CGFloat?
    @State private var presentingSafariView = false
    
    var body: some View {
        let previewContentClass = blockData?.contentClass ?? ""
        let previewTitle = blockData?.title ?? ""
        let previewImgURL = blockData?.image?.large.url ?? nil
        let previewText = blockData?.content ?? ""
        let previewAttachment = blockData?.attachment ?? nil
        let previewURL = previewContentClass == "Link" ? blockData?.source?.url : previewImgURL
        // TODO: embeds
        
        VStack {
            if previewImgURL != nil {
                VStack(alignment: .leading) {
                    if previewContentClass == "Link" {
                        HStack(spacing: 4) {
                            Text("\(previewTitle)")
                                .foregroundStyle(Color("text-primary"))
                                .lineLimit(1)
                            
                            Image(systemName: "link")
                                .foregroundStyle(Color("surface-text-secondary"))
                                .imageScale(.small)
                            
                            Text("\(previewURL ?? "")")
                                .lineLimit(1)
                        }
                        .font(.system(size: 13))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color("surface-secondary"))
                    }
                    
                    ImagePreview(imageURL: previewImgURL!)
                        .pinchToZoom()
                }
                .onTapGesture {
                    self.presentingSafariView = true
                }
                .safariView(isPresented: $presentingSafariView) {
                    SafariView(
                        url: URL(string: previewURL!)!,
                        configuration: SafariView.Configuration(
                            entersReaderIfAvailable: false,
                            barCollapsingEnabled: true
                        )
                    )
                    .preferredBarAccentColor(.clear)
                    .preferredControlAccentColor(.accentColor)
                    .dismissButtonStyle(.done)
                }
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
                    .padding(display == "Table" ? 8 : display == "Large Grid" ? 12 : 16)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
                    .multilineTextAlignment(.leading)
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
                    .padding(12)
                    .foregroundStyle(Color("text-primary"))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("surface"))
                    )
                    .font(.system(size: display == "Table" ? 12 : fontSize ?? 16))
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
                    .multilineTextAlignment(.leading)
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
