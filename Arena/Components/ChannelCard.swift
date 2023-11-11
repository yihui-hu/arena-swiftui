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
    
    @Default(.pinnedChannels) var pinnedChannels
    
    struct HorizontalImageScroll: View {
        let contents: [Block]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(contents, id: \.id) { content in
                        ChannelCardContentPreview(block: content)
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
            VStack(alignment: .leading) {
                HStack() {
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
                    
                    HStack(spacing: 8) {
                        Text("\(channel.length) items")
                            .font(.system(size: 15))
                            .foregroundColor(Color("surface-text-secondary"))
                            .fontWeight(.medium)
                        
                        if (pinnedChannels.contains(channel.id)) {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(Color("surface-text-secondary"))
                                .imageScale(.small)
                        }
                    }
                }
                .lineLimit(1)
                
                if let contents = channel.contents, !contents.isEmpty {
                    let channelContents = Array(contents.prefix(6)) // TODO: Load more for larger screen sizes?
                    HorizontalImageScroll(contents: channelContents)
                }
            }
            .fontDesign(.rounded)
            .padding(16)
            .background(Color("surface"))
            .cornerRadius(32)
        }
    }
}
