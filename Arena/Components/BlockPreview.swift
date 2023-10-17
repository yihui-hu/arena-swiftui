//
//  BlockPreview.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

// Priority of preview:
// 1. Image
// 2. Text content
// 3. Embed (?)
// 4. Attachment (find way to display pdfs, else just show file extension)
// 5. Error / placeholder image

// This is separate from actually displaying PDFs or playing MP3s -- do that in separate BlockContentScreen or something

struct BlockPreview: View {
    let blockData: Block?
    
    var body: some View {
        let previewImg = blockData?.image?.large.url ?? nil // images
        let previewText = blockData?.content ?? "" // texts
        let previewAttachment = blockData?.attachment ?? nil // attachments
        
        VStack {
            if previewImg != nil {
                AsyncImage(url: URL(string: previewImg ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(alignment: .center)
            } else if previewText != "" {
                Text(previewText)
            } else if previewAttachment != nil {
                Text(previewAttachment?.fileExtension ?? "")
            } else {
                Text("No preview available.")
            }
        }
    }
}

//#Preview {
//    ScrollView {
//        Group {
//            BlockPreview(blockData: BlockData(blockId: 24185173).block ?? nil) // image
//            BlockPreview(blockData: BlockData(blockId: 24185174).block ?? nil) // text block
//            BlockPreview(blockData: BlockData(blockId: 24185184).block ?? nil) // pdf
//            BlockPreview(blockData: BlockData(blockId: 24185218).block ?? nil) // mp3
//        }
//    }
//}
