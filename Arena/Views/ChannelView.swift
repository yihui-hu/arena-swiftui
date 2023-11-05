//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import Modals

enum SortOption: String {
    case position = "Position"
    case newest = "Newest First"
    case oldest = "Oldest First"
}

struct ChannelView: View {
    @StateObject private var channelData: ChannelData
    @Environment(\.dismiss) private var dismiss
    let channelSlug: String
    
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
                ZStack {}.id(0) // Hacky implementation of scroll to top when switching sorting option
                
                ChannelViewHeader(channelData: channelData)
                
                LazyVGrid(columns: columns, spacing: gridGap) {
                    ForEach(channelData.contents ?? [], id: \.self.id) { block in
                        NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                            ChannelContentPreview(block: block, gridItemSize: gridItemSize)
                        }
                        .onAppear {
                            if let channelContent = channelData.contents, channelContent.count >= 8 {
                                if channelContent[channelContent.count - 8].id == block.id {
                                    if !channelData.isContentsLoading {
                                        channelData.loadMore(channelSlug: self.channelSlug)
                                    }
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
                
                // TODO: Make a channelData.finishedLoading state
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        print("Dismissing")
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 4) {
                        Button(action: {
                            print("Changing display mode")
                        }) {
                            Image(systemName: "square.grid.2x2")
                        }
                        
                        
                        Button(action: {
                            print("Sorting order")
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                    .foregroundStyle(Color("surface-text-secondary"))
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
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

struct ChannelViewHeader: View {
    @StateObject var channelData: ChannelData
    
    var body: some View {
        // TODO: Indicator for whether channel is public or private
        VStack(spacing: 16) {
            
            HStack {
                if let channelTitle = channelData.channel?.title, !channelTitle.isEmpty {
                    Text("\(channelTitle)")
                } else {
                    Text("–")
                }
            }
            .fontDesign(.rounded)
            .font(.system(size: 18))
            .foregroundColor(Color("text-primary"))
            .fontWeight(.semibold)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                HStack {
                    if let channelDescription = channelData.channel?.metadata?.description, !channelDescription.isEmpty {
                        Text("\(channelDescription)")
                    }
                }
                .font(.system(size: 15))
                .fontDesign(.default)
                .foregroundColor(Color("text-secondary"))
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                
                if let channelOwner = channelData.channel?.user.fullName {
                    // Get the list of collaborators
                    if let collaborators = channelData.channel?.collaborators, !collaborators.isEmpty {
                        let collaboratorList = collaborators.map { $0.fullName }.joined(separator: ", ")
                        VStack {
                            Text("by ")
                                .foregroundColor(Color("text-secondary")) +
                            Text("\(channelOwner)")
                                .foregroundColor(Color("text-primary")) +
                            Text(" with ")
                                .foregroundColor(Color("text-secondary")) +
                            Text("\(collaboratorList)")
                                .foregroundColor(Color("text-primary"))
                            
                        }
                        .font(.system(size: 15))
                        .fontDesign(.default)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                    } else {
                        // If there are no collaborators, display only the channel owner
                        VStack {
                            Text("by ")
                                .foregroundColor(Color("text-secondary")) +
                            Text("\(channelOwner)")
                                .foregroundColor(Color("text-primary"))
                        }
                        .font(.system(size: 15))
                        .fontDesign(.default)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                    }
                }
            }
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Button(action: {
                        print("All")
                    }) {
                        HStack(spacing: 8) {
                            Text("All")
                            
                            if let channelLength = channelData.channel?.length {
                                Text("\(channelLength)")
                                    .foregroundStyle(Color("surface-text-secondary"))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color("surface"))
                    .cornerRadius(40)
                    
                    Button(action: {
                        print("Blocks")
                    }) {
                        Text("Blocks")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color("surface"))
                    .cornerRadius(40)
                    
                    Button(action: {
                        print("Channels")
                    }) {
                        Text("Channels")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color("surface"))
                    .cornerRadius(40)
                    
                    Button(action: {
                        print("Connections")
                    }) {
                        Text("Connections")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color("surface"))
                    .cornerRadius(40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .font(.system(size: 15))
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
}

#Preview {
    ModalStackView {
        NavigationView {
            // ChannelView(channelSlug: "hi-christina-will-you-go-out-with-me")
            ChannelView(channelSlug: "posterikas")
            // ChannelView(channelSlug: "competitive-design-website-repo")
            // ChannelView(channelSlug: "christina-bgfz4hkltss")
            // ChannelView(channelSlug: "arena-swift-models-test")
        }
    }
}

