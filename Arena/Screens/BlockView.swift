//
//  BlockView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import VTabView

struct BlockView: View {
    let blockData: Block
    let channelSlug: String
    @ObservedObject private var channelData: ChannelData
    @State private var currentIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    init(blockData: Block, channelData: ChannelData, channelSlug: String) {
        self.blockData = blockData
        self.channelData = channelData
        self.channelSlug = channelSlug
        _currentIndex = State(initialValue: channelData.contents?.firstIndex(where: { $0.id == blockData.id }) ?? 0)
    }
    
    var body: some View {
        VTabView(selection: $currentIndex) {
            ForEach(channelData.contents ?? [], id: \.self.id) { block in
                // Display the block content
                VStack {
                    BlockPreview(blockData: block, fontSize: 16) // replace with high quality block preview
                    Text("\(block.title)")
                    Text("\(block.createdAt)")
                    Text("Connected by \(block.connectedByUsername ?? "")")
                }
                .foregroundColor(Color("text-primary"))
                .tag(channelData.contents?.firstIndex(of: block) ?? 0)
                .onAppear {
                    if channelData.contents?.last?.id ?? -1 == block.id {
                        if !channelData.isContentsLoading {
                            // Load more content when the last block is reached
                            channelData.loadMore(channelSlug: self.channelSlug)
                            print(channelData.contents?.count ?? "")
                        }
                    }
                }
            }
        }
        .background(Color("background"))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
