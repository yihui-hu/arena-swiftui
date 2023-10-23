//
//  ChannelCard.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI

struct ChannelCard: View {
    let channel: ArenaChannelPreview
    @State private var isFaded = false
    
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
                    
                    Text("\(channel.length) items")
                        .font(.system(size: 15))
                        .foregroundColor(Color("surface-text-secondary"))
                        .fontWeight(.medium)
                }
                .lineLimit(1)
                
                if let contents = channel.contents, !contents.isEmpty {
                    HorizontalImageScroll(contents: Array(contents.prefix(6)))
                }
            }
            .fontDesign(.rounded)
            .padding(16)
            .background(Color("surface"))
            .cornerRadius(32)
            .opacity(isFaded ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.1)) {
                    isFaded = true
                }
            }
            .onDisappear {
                withAnimation(.easeOut(duration: 0.1)) {
                    isFaded = false
                }
            }
        }
    }
}
