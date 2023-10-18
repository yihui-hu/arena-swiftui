//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

struct ChannelView: View {
    @StateObject var channelData: ChannelData
    let channelSlug: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var selection = "Newest First"
    let colors = ["Newest First", "Oldest First"]
    
    init(channelSlug: String) {
        self.channelSlug = channelSlug
        _channelData = StateObject(wrappedValue: ChannelData(channelSlug: channelSlug, selection: "Newest First"))
    }
    
    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 5), count: 2)
        let gridItemSize = (UIScreen.main.bounds.width - 40) / 2
        let gridItemAspectRatio: CGFloat = 1.0
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(channelData.contents ?? [], id: \.self.id) { block in
                    NavigationLink(destination: destinationView(for: block)) {
                        if block.baseClass == "Block" {
                            BlockPreview(blockData: block)
                                .frame(width: gridItemSize, height: gridItemSize * gridItemAspectRatio)
                                .border(Color(red: 0.3333, green: 0.3333, blue: 0.3333, opacity: 0.4), width: 0.5)
                            // figure out better preview for channel
                        } else {
                            Text("\(block.title) by \(block.user.username)")
                                .frame(width: gridItemSize, height: gridItemSize * gridItemAspectRatio)
                                .border(Color.orange, width: 0.5)
                        }
                    }
                }
            }
            
            if channelData.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Color.clear
                    .onAppear {
                        channelData.loadMore(channelSlug: self.channelSlug)
                    }
            }
            
            if channelData.currentPage > channelData.totalPages {
                Text("Finished loading all blocks")
                    .foregroundStyle(Color.gray)
            }
            
            Text("\n\n")
        }
        .contentMargins(.top, 10)
        .contentMargins(.horizontal, 10)
        .padding(.bottom, 20)
        .scrollIndicators(.hidden)
        .refreshable {
            channelData.refresh(channelSlug: self.channelSlug)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Select a sort order", selection: $selection) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .onChange(of: selection, initial: true) { oldSelection, newSelection in
            if oldSelection != newSelection {
                channelData.selection = newSelection
                channelData.refresh(channelSlug: self.channelSlug)
            }
        }
    }
}

@ViewBuilder
func destinationView(for block: Block) -> some View {
    if block.baseClass == "Block" {
        BlockView(blockData: block)
    } else {
        ChannelView(channelSlug: block.slug ?? "")
    }
}

#Preview {
    NavigationView {
        ChannelView(channelSlug: "competitive-design-website-repo")
    }
}

