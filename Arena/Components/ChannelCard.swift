//
//  ChannelCard.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI
import Defaults

struct ChannelCard: View {
    let channel: ArenaChannelPreview
    let showPin: Bool?
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init(channel: ArenaChannelPreview, showPin: Bool? = true) {
        self.channel = channel
        self.showPin = showPin
    }
    
    private struct HorizontalImageScroll: View {
        let contents: [Block]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(contents, id: \.id) { content in
                        VStack {
                            if content.baseClass == "Block" {
                                ChannelCardBlockPreview(blockData: content, fontSize: 14)
                                    .frame(maxWidth: 250)
                                    .background(Color("surface-secondary"))
                            } else {
                                ChannelPreview(blockData: content, fontSize: 14, display: "Default")
                                    .frame(width: 132, height: 132)
                                    .background(Color("surface-secondary"))
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    HStack(spacing: 4) {
                        if channel.status != "closed" {
                            Image(systemName: "circle.fill")
                                .scaleEffect(0.5)
                                .foregroundColor(channel.status == "public" ? Color.green : Color.red)
                        }
                        Text("\(channel.title)")
                            .foregroundColor(Color("text-primary"))
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
//                        if channel.status != "closed" {
//                            Text("\(channel.status == "public" ? "open" : "private"), \(channel.length) items")
//                                .font(.system(size: 15))
//                                .foregroundColor(Color("surface-text-secondary"))
//                                .fontWeight(.medium)
//                        } else {
                            Text("\(channel.length) items")
                                .font(.system(size: 15))
                                .foregroundColor(Color("surface-text-secondary"))
                                .fontWeight(.medium)
//                        }
                    }
                    
                    if let showPin = showPin, showPin {
                        if (pinnedChannels.contains(channel.id)) {
                            Image(systemName: "bookmark.fill")
                                .foregroundStyle(Color("surface-text-secondary"))
                                .imageScale(.small)
                        }
                    }
                }
                .lineLimit(1)
                
                if let contents = channel.contents, !contents.isEmpty {
                    let channelContents = Array(contents.prefix(6)) // TODO: Load more for larger screen sizes
                    HorizontalImageScroll(contents: channelContents)
                }
            }
            .fontDesign(.rounded)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 14)
            .background(Color("surface"))
            .cornerRadius(32)
        }
        .simultaneousGesture(TapGesture().onEnded{
            let id = UUID()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm, d MMM y"
            let timestamp = formatter.string(from: Date.now)
            Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "channel", subtype: channel.status, itemId: channel.slug, timestamp: timestamp, mainText: channel.title, subText: String(channel.length), imageUrl: String(channel.id)), at: 0)
        })
    }
}
