//
//  ContextMenus.swift
//  Arena
//
//  Created by Yihui Hu on 4/12/23.
//

import SwiftUI
import Defaults
import UniformTypeIdentifiers

struct BlockContextMenu: View {
    let block: Block
    let showViewOption: Bool
    let channelData: ChannelData?
    let channelSlug: String?
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            Defaults[.connectSheetOpen] = true
            Defaults[.connectItemId] = block.id
            Defaults[.connectItemType] = "Block"
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
                Defaults[.toastMessage] = "Saving image..."
                Defaults[.showToast] = true
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data) ?? UIImage()
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Defaults[.showToast] = false
                }
                task.resume()
            } label: {
                Label("Save Image", systemImage: "square.and.arrow.down")
            }
        } else if block.contentClass == "Text" {
            Button {
                UIPasteboard.general.setValue((block.content ?? "Error copying block content") as String,
                            forPasteboardType: UTType.plainText.identifier)
                Defaults[.toastMessage] = "Copied!"
                Defaults[.showToast] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Defaults[.showToast] = false
                }
            } label: {
                Label("Copy", systemImage: "clipboard")
            }
        }
        
        if block.contentClass == "Link" {
            Button {
                Defaults[.safariViewURL] = block.source?.url ?? "https://are.na/source/\(block.id)"
                Defaults[.safariViewOpen] = true
            } label: {
                Label("Open URL", systemImage: "safari")
            }
        }
        
        if showViewOption, channelData != nil, channelSlug != nil {
            NavigationLink(destination: BlockView(blockData: block, channelData: channelData!, channelSlug: channelSlug!)) {
                Label("View Block", systemImage: "eye")
            }
            .simultaneousGesture(TapGesture().onEnded{
                AddBlockToRabbitHole(block: block)
            })
        }
    }
}

struct BlockContextMenuPreview: View {
    let block: Block
    
    var body: some View {
        let img = block.image
        
        if img != nil {
            ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Grid", isContextMenuPreview: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ChannelViewBlockPreview(blockData: block, fontSize: 18, display: "Feed", isContextMenuPreview: true)
                .padding(32)
                .frame(width: 400, height: 400)
        }
    }
}

struct ChannelContextMenu: View {
    let channel: Block // I deeply regret and apologise for this semantic mess 🙏
    let showViewOption: Bool
    
    var body: some View {
        Button {
            Defaults[.connectSheetOpen] = true
            Defaults[.connectItemId] = channel.id
            Defaults[.connectItemType] = "Channel"
        } label: {
            Label("Connect", systemImage: "arrow.right")
        }

        if showViewOption {
            NavigationLink(destination: ChannelView(channelSlug: channel.slug ?? "")) {
                Label("View Channel", systemImage: "eye")
            }
            .simultaneousGesture(TapGesture().onEnded{
                let id = channel.id
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm, d MMM y"
                let timestamp = formatter.string(from: Date.now)
                Defaults[.rabbitHole].insert(RabbitHoleItem(id: String(id), type: "channel", subtype: channel.status ?? "0", itemId: channel.slug ?? "", timestamp: timestamp, mainText: channel.title, subText: String(channel.length ?? 0), imageUrl: ""), at: 0)
            })
        }
    }
}

struct ChannelContextMenuPreview: View {
    let channel: Block
    
    var body: some View {
        VStack {
            Text("\(channel.title)")
                .foregroundStyle(Color("arena-orange"))
            Text("by \(channel.user.username)")
                .foregroundStyle(Color("text-primary"))
        }
        .padding(32)
        .frame(width: 400, height: 400)
    }
}
