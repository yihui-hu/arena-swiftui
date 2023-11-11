//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import Shimmer
import Defaults

enum SortOption: String, CaseIterable {
    case position = "Position"
    case newest = "Newest First"
    case oldest = "Oldest First"
}

enum DisplayOption: String, CaseIterable {
    case grid = "Grid"
    case largeGrid = "Large Grid"
    case feed = "Feed"
    case table = "Table"
    // case book = "Book"
}

enum ContentOption: String, CaseIterable {
    case all = "All"
    case blocks = "Blocks"
    case channels = "Channels"
    case connections = "Connections"
}

struct ChannelView: View {
    @StateObject private var channelData: ChannelData
    @Environment(\.dismiss) private var dismiss
    let channelSlug: String
    
    @State private var selection = SortOption.position
    let sortOptions = SortOption.allCases
    
    @State private var display = DisplayOption.grid
    let displayOptions = DisplayOption.allCases
    
    @State private var content = ContentOption.all
    let contentOptions = ContentOption.allCases
    
//    @Default(.pinnedChannels) var pinnedChannels
//    let pinImage = pinnedChannels.contains(channelData.channel.id) ? "pin.slash.fill" : "pin.fill"
    
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
    
    var displayLabel: Image {
        switch display {
        case .grid:
            return Image(systemName: "square.grid.2x2")
        case .largeGrid:
            return Image(systemName: "square.grid.3x3")
        case .table:
            return Image(systemName: "rectangle.grid.1x2")
        case .feed:
            return Image(systemName: "square")
        }
    }
    
    var body: some View {
        // Channel slug is empty, show error state
        //        if channelSlug == "" { errorState() }
        
        // Setting up grid
        let gridGap: CGFloat = 8
        let gridSpacing = display.rawValue != "Large Grid" ? gridGap + 16 : gridGap
        let gridColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridGap), count: display.rawValue == "Grid" ? 2 : display.rawValue == "Large Grid" ? 3 : 1)
        let gridItemSize = display.rawValue == "Grid" ? (UIScreen.main.bounds.width - (gridGap * 3)) / 2 : display.rawValue == "Large Grid" ? (UIScreen.main.bounds.width - (gridGap * 4)) / 3 : (UIScreen.main.bounds.width - (gridGap * 2))
        
        ScrollViewReader { proxy in
            ScrollView {
                ZStack {}.id(0) // Hacky implementation of scroll to top when switching sorting option
                
                ChannelViewHeader(channelData: channelData, content: $content, contentOptions: contentOptions)
                
                if display.rawValue == "Table" {
                    LazyVStack(spacing: 8) {
                        ForEach(channelData.contents ?? [], id: \.self.id) { block in
                            NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                                ChannelContentPreview(block: block, gridItemSize: gridItemSize, display: display.rawValue)
                            }
                            .onAppear {
                                loadMoreChannelData(channelData: channelData, channelSlug: self.channelSlug, block: block)
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                        ForEach(channelData.contents ?? [], id: \.self.id) { block in
                            NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                                ChannelContentPreview(block: block, gridItemSize: gridItemSize, display: display.rawValue)
                            }
                            .onAppear {
                                loadMoreChannelData(channelData: channelData, channelSlug: self.channelSlug, block: block)
                            }
                        }
                    }
                }
                
                ZStack {
                    if (channelData.isLoading || channelData.isContentsLoading) {
                        LoadingSpinner()
                    }
                }
                
                if channelData.currentPage > channelData.totalPages {
                    Text("End of channel")
                        .padding(.top, 24)
                        .foregroundStyle(Color("surface-text-secondary"))
                }
            }
            .contentMargins(.bottom, 88)
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
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 4) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "pin.fill")
                        }
                        
                        Menu {
                            Picker("Select a display mode", selection: $display) {
                                ForEach(displayOptions, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                        } label: {
                            displayLabel
                        }
                        
                        Menu {
                            Picker("Select a sort order", selection: $selection) {
                                ForEach(sortOptions, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                        } label: {
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
                    proxy.scrollTo(0) // TODO: Decide if want withAnimation { proxy.scrollTo(0) }
                    channelData.selection = newSelection
                    channelData.refresh(channelSlug: self.channelSlug, selection: newSelection)
                }
            }
            .onChange(of: display, initial: true) { oldDisplay, newDisplay in
                if oldDisplay != newDisplay {
                    proxy.scrollTo(0)
                }
            }
        }
    }
    
//    private func togglePin(_ channelId: Int) {
//        if pinnedChannels.contains(channelId) {
//            pinnedChannels.removeAll { $0 == channelId }
//        } else {
//            pinnedChannels.append(channelId)
//        }
//    }
}

func loadMoreChannelData(channelData: ChannelData, channelSlug: String, block: Block) {
    if let contents = channelData.contents,
       contents.count >= 8,
       contents[contents.count - 8].id == block.id,
       !channelData.isContentsLoading {
        channelData.loadMore(channelSlug: channelSlug)
    }
}

struct ChannelViewHeader: View {
    @StateObject var channelData: ChannelData
    @Binding var content: ContentOption
    var contentOptions: [ContentOption]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                if let channelTitle = channelData.channel?.title, !channelTitle.isEmpty {
                    HStack(spacing: 4) {
                        if let status = channelData.channel?.status, status != "closed" {
                            Image(systemName: "circle.fill")
                                .scaleEffect(0.5)
                                .foregroundColor(status == "public" ? Color.green : Color.red)
                        }
                        Text("\(channelTitle)")
                            .foregroundColor(Color("text-primary"))
                            .fontWeight(.semibold)
                    }
                } else {
                    Text("----")
                        .shimmering()
                        .redacted(reason: .placeholder)
                }
            }
            .fontDesign(.rounded)
            .font(.system(size: 18))
            .foregroundColor(Color("text-primary"))
            .fontWeight(.semibold)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                // channelDescription
                HStack {
                    if let channelDescription = channelData.channel?.metadata?.description, !channelDescription.isEmpty {
                        Text("\(channelDescription)")
                    }
                }
                .font(.system(size: 15))
                .fontWeight(.regular)
                .fontDesign(.default)
                .foregroundColor(Color("text-secondary"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                
                // by ChannelOwner + Collaborators text
                if let channelOwner = channelData.channel?.user.fullName {
                    let ownerText = Text("by ")
                        .foregroundColor(Color("text-secondary")) +
                    Text("\(channelOwner)")
                        .foregroundColor(Color("text-primary"))
                    
                    if let collaborators = channelData.channel?.collaborators, !collaborators.isEmpty {
                        let collaboratorList = collaborators.map { $0.fullName }.joined(separator: ", ")
                        let collaboratorText = Text(" with ")
                            .foregroundColor(Color("text-secondary")) +
                        Text("\(collaboratorList)")
                            .foregroundColor(Color("text-primary"))
                        
                        VStack {
                            ownerText + collaboratorText
                        }
                        .font(.system(size: 15))
                        .fontDesign(.default)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                    } else {
                        VStack {
                            ownerText
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
                    ForEach(contentOptions, id: \.self) { option in
                        Button(action: {
                            content = option
                        }) {
                            HStack(spacing: 8) {
                                Text("\(option.rawValue)")
                                    .foregroundStyle(content == option ? Color("text-primary") : Color("surface-text-secondary"))
                                
                                if option.rawValue == "All", let channelLength = channelData.channel?.length {
                                    Text("\(channelLength)")
                                        .foregroundStyle(Color("surface-text-secondary"))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("surface"))
                        .cornerRadius(40)
                    }
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
    NavigationView {
        // ChannelView(channelSlug: "hi-christina-will-you-go-out-with-me")
        ChannelView(channelSlug: "posterikas")
        // ChannelView(channelSlug: "competitive-design-website-repo")
        // ChannelView(channelSlug: "christina-bgfz4hkltss")
        // ChannelView(channelSlug: "arena-swift-models-test")
    }
}

