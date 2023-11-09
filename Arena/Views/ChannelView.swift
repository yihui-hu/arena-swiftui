//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import Modals

enum SortOption: String, CaseIterable {
    case position = "Position"
    case newest = "Newest First"
    case oldest = "Oldest First"
}

enum DisplayOption: String, CaseIterable {
    case grid = "Grid"
    case feed = "Feed"
    case table = "Table"
}

struct ChannelView: View {
    @StateObject private var channelData: ChannelData
    @Environment(\.dismiss) private var dismiss
    let channelSlug: String
    
    @State private var selection = SortOption.position
    let sortOptions = SortOption.allCases
    
    @State private var display = DisplayOption.grid
    let displayOptions = DisplayOption.allCases
    
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
        case .table:
            return Image(systemName: "rectangle.grid.1x2")
        case .feed:
            return Image(systemName: "square")
        }
    }
    
    var body: some View {
        // Channel slug is empty, show error state
//        if channelSlug == "" {
//
//        }
        
        // Setting up grid
        let gridGap: CGFloat = 8
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridGap), count: display.rawValue == "Grid" ? 2 : 1)
        let gridItemSize = display.rawValue == "Grid" ? (UIScreen.main.bounds.width - (gridGap * 3)) / 2 : (UIScreen.main.bounds.width - (gridGap * 3))
        
        ScrollViewReader { proxy in
            ScrollView {
                // Hacky implementation of scroll to top when switching sorting option
                ZStack {}.id(0)
                
                ChannelViewHeader(channelData: channelData)
                
                if display.rawValue == "Table" {
                    LazyVStack(spacing: 8) {
                        ForEach(channelData.contents ?? [], id: \.self.id) { block in
                            NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                                ChannelContentPreview(block: block, gridItemSize: gridItemSize, display: display.rawValue)
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
                } else {
                    LazyVGrid(columns: columns, spacing: gridGap + 16) {
                        ForEach(channelData.contents ?? [], id: \.self.id) { block in
                            NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                                ChannelContentPreview(block: block, gridItemSize: gridItemSize, display: display.rawValue)
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
                    withAnimation {
                        proxy.scrollTo(0)
                    }
                    channelData.selection = newSelection
                    channelData.refresh(channelSlug: self.channelSlug, selection: newSelection)
                }
            }
            .onChange(of: display, initial: true) { oldDisplay, newDisplay in
                if oldDisplay != newDisplay {
                    withAnimation {
                        proxy.scrollTo(0)
                    }
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
            ChannelView(channelSlug: "hi-christina-will-you-go-out-with-me")
            // ChannelView(channelSlug: "posterikas")
            // ChannelView(channelSlug: "competitive-design-website-repo")
            // ChannelView(channelSlug: "christina-bgfz4hkltss")
            // ChannelView(channelSlug: "arena-swift-models-test")
        }
    }
}

