//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI

enum SortOption: String {
    case position = "Position"
    case newest = "Newest First"
    case oldest = "Oldest First"
}

struct ChannelView: View {
    @StateObject private var channelData: ChannelData
    let channelSlug: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var selection = SortOption.position
    let sortOptions = [SortOption.position, SortOption.newest, SortOption.oldest]
    
    init(channelSlug: String) {
        self.channelSlug = channelSlug
        self._channelData = StateObject(wrappedValue: ChannelData(channelSlug: channelSlug, selection: SortOption.position))
    }
    
    @ViewBuilder
    private func destinationView(for block: Block, channelData: ChannelData, channelSlug: String) -> some View {
        if block.baseClass == "Block" {
            BlockView(blockData: block, channelData: channelData, channelSlug: channelSlug)
        } else {
            ChannelView(channelSlug: block.slug ?? "")
        }
    }
    
    var body: some View {
        // Setting up grid
        let gridGap: CGFloat = 8
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridGap), count: 2)
        let gridItemSize = (UIScreen.main.bounds.width - (gridGap * 3)) / 2
        
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {}.id(0) // Hacky implementation of scroll to top
                
                LazyVGrid(columns: columns, spacing: gridGap) {
                    ForEach(channelData.contents ?? [], id: \.self.id) { block in
                        NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                            ChannelContentPreview(block: block, gridItemSize: gridItemSize)
                        }
                        .onAppear {
                            if channelData.contents?.last?.id ?? -1 == block.id {
                                if !channelData.isContentsLoading {
                                    channelData.loadMore(channelSlug: self.channelSlug)
                                }
                            }
                        }
                    }
                }
                
                ZStack {
                    if (channelData.isLoading || channelData.isContentsLoading) {
                        LoadingSpinner()
                    }
                }
                
                // Make a channelData.finishedLoading state
                if channelData.currentPage > channelData.totalPages {
                    Text("End of channel")
                        .foregroundStyle(Color("surface-text-secondary"))
                }
            }
            .background(Color("background"))
            .contentMargins(gridGap)
            .contentMargins(.leading, 0, for: .scrollIndicators)
            .refreshable {
                do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                channelData.refresh(channelSlug: self.channelSlug, selection: selection)
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
                        ForEach(sortOptions, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onChange(of: selection, initial: true) { oldSelection, newSelection in
                if oldSelection != newSelection {
                    withAnimation {
                        proxy.scrollTo(0)
                    }
                    channelData.selection = newSelection
                    channelData.refresh(channelSlug: self.channelSlug, selection: newSelection)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        // ChannelView(channelSlug: "hi-christina-will-you-go-out-with-me")
        ChannelView(channelSlug: "competitive-design-website-repo")
        // ChannelView(channelSlug: "christina-bgfz4hkltss")
        // ChannelView(channelSlug: "arena-swift-models-test")
    }
}

