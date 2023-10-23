//
//  BlockPreview.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

// This is separate from actually displaying PDFs or playing MP3s -- do that in separate BlockContentScreen or something

struct BlockPreview: View {
    let blockData: Block?
    let fontSize: CGFloat?
    
    var body: some View {
        let previewImgURL = blockData?.image?.thumb.url ?? nil
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
                    .padding(16)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else {
                Text("No preview available.")
            }
        }
    }
}

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
                ImagePreview(imageURL: previewImgURL!)
                    .frame(height: 132)
            } else if previewText != "" {
                Text(previewText)
                    .padding(16)
                    .frame(width: 132, height: 132)
                    .foregroundStyle(Color("text-primary"))
                    .font(.system(size: fontSize ?? 16))
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
                    .padding(16)
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
