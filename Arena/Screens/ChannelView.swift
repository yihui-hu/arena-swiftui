//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

struct ChannelView: View {
    @StateObject var channelFetcher: ChannelFetcher
    let channelSlug: String
    
    init(channelSlug: String) {
        self.channelSlug = channelSlug
        _channelFetcher = StateObject(wrappedValue: ChannelFetcher(channelSlug: channelSlug))
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVStack {
                    ForEach(channelFetcher.channel?.contents ?? [], id: \.self.id) { item in
                        NavigationLink(destination: BlockView()) {
                            Text("\(item.title)")
                        }
                    }
                    
                    if channelFetcher.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Color.clear
                            .onAppear {
                                channelFetcher.loadMore(channelSlug: self.channelSlug)
                            }
                    }
                    
                    if channelFetcher.currentPage > channelFetcher.totalPages {
                        Text("Finished loading all blocks!")
                    }
                }
            }
            .contentMargins(20)
            .scrollIndicators(.hidden)
            .refreshable {
                channelFetcher.refresh(channelSlug: self.channelSlug)
            }
        }
    }
}

#Preview {
    ChannelView(channelSlug: "software-4mduyaqjx4i")
}

