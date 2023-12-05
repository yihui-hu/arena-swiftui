//
//  ContextMenus.swift
//  Arena
//
//  Created by Yihui Hu on 4/12/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct BlockContextMenu: View {
    let block: Block
    let showViewOption: Bool
    let channelData: ChannelData?
    let channelSlug: String?
    @Environment(\.openURL) var openURL
    @Binding var presentingSafariView: Bool
    
    var body: some View {
        Button {
            // Perform connecting
        } label: {
            Label("Connect", systemImage: "arrow.right")
        }
        
// TODO: Add support for downloading attachments
//        if block.contentClass == "Attachment" {
//            Button {
//                print("Download attachment")
//            } label: {
//                Label("Download", systemImage: "square.and.arrow.down")
//            }
//        }
        
        if let imageURL = block.image?.original.url, let url = URL(string: imageURL) {
            Button {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data) ?? UIImage()
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image)
                    }
                }
                task.resume()
            } label: {
                Label("Save Image", systemImage: "square.and.arrow.down")
            }
        } else if block.contentClass == "Text" {
            Button {
                UIPasteboard.general.setValue((block.content ?? "Error copying block content") as String,
                            forPasteboardType: UTType.plainText.identifier)
            } label: {
                Label("Copy", systemImage: "clipboard")
            }
        }
        
        if block.contentClass == "Link" {
            Button {
                presentingSafariView = true
            } label: {
                Label("Open URL", systemImage: "safari")
            }
        }
        
        // TODO: Handle nil channelData and channelSlug
        if block.contentClass == "Channel" {
            Button {
                print("Navigate to channel")
            } label: {
                Label("View", systemImage: "eye")
            }
        } else if showViewOption, channelData != nil, channelSlug != nil {
            NavigationLink(destination: BlockView(blockData: block, channelData: channelData!, channelSlug: channelSlug!)) {
                Label("View Block", systemImage: "eye")
            }
        }
    }
}

// TODO: Handle channel content preview
struct BlockContextMenuPreview: View {
    let block: Block
    
    var body: some View {
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
