//
//  ExploreView.swift
//  Arena
//
//  Created by Yihui Hu on 23/10/23.
//

import SwiftUI
import SmoothGradient
import NukeUI
import Defaults
import UniformTypeIdentifiers

enum Selection: String, CaseIterable {
    case blocks = "Blocks"
    case channels = "Channels"
    case users = "Users"
}

struct ExploreView: View {
    @StateObject private var exploreData: ExploreData
    @State private var selection = Selection.blocks
    @State private var changedSelection: Bool = false
    let selectionOptions = Selection.allCases
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init() {
        self._exploreData = StateObject(wrappedValue: ExploreData())
    }
    
    var selectionLabel: some View {
        switch selection {
        case .blocks:
            return Image(systemName: "square.grid.2x2")
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .frame(width: 18, height: 18)
        case .channels:
            return Image(systemName: "water.waves")
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .frame(width: 18, height: 18)
        case .users:
            return Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .frame(width: 18, height: 18)
        }
    }
    
    var body: some View {
        let gridGap: CGFloat = 8
        let gridSpacing = gridGap + 8
        let gridColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridGap), count: 2)
        let displayWidth = UIScreen.main.bounds.width
        let gridItemSize = (displayWidth - (gridGap * 3) - 16) / 2
        
        NavigationStack {
            VStack {
                if let exploreResults = exploreData.exploreResults {
                    ScrollView {
                        if selection.rawValue == "Blocks" {
                            LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                                ForEach(Array(zip(exploreResults.blocks.indices, exploreResults.blocks)), id: \.0) { _, block in
                                    NavigationLink(destination: SingleBlockView(block: block)) {
                                        VStack(spacing: 8) {
                                            ChannelViewBlockPreview(blockData: block, fontSize: 12, display: "Grid", isContextMenuPreview: false)
                                                .frame(width: gridItemSize, height: gridItemSize)
                                                .background(Color("background"))
                                                .contextMenu {
                                                    BlockContextMenu(block: block, showViewOption: false, channelData: nil, channelSlug: "")
                                                    
                                                    NavigationLink(destination: SingleBlockView(block: block)) {
                                                        Label("View Block", systemImage: "eye")
                                                    }
                                                    .simultaneousGesture(TapGesture().onEnded{
                                                        AddBlockToRabbitHole(block: block)
                                                    })
                                                } preview: {
                                                    BlockContextMenuPreview(block: block)
                                                }
                                            
                                            ContentPreviewMetadata(block: block, display: "Grid")
                                                .padding(.horizontal, 12)
                                        }
                                        .onAppear {
                                            if exploreResults.blocks.count >= 8 {
                                                if exploreResults.blocks[exploreResults.blocks.count - 8].id == block.id {
                                                    exploreData.loadMore()
                                                }
                                            }
                                        }
                                    }
                                    .simultaneousGesture(TapGesture().onEnded{
                                        AddBlockToRabbitHole(block: block)
                                    })
                                }
                            }
                        } else {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                if selection.rawValue == "Channels" {
                                    ForEach(exploreResults.channels, id: \.id) { channel in
                                        NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                            SearchChannelPreview(channel: channel)
                                        }
                                        .onAppear {
                                            if exploreResults.channels.count >= 8 {
                                                if exploreResults.channels[exploreResults.channels.count - 8].id == channel.id {
                                                    exploreData.loadMore()
                                                }
                                            }
                                        }
                                        .simultaneousGesture(TapGesture().onEnded{
                                            let id = channel.id
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "HH:mm, d MMM y"
                                            let timestamp = formatter.string(from: Date.now)
                                            Defaults[.rabbitHole].insert(RabbitHoleItem(id: String(id), type: "channel", subtype: channel.status, itemId: channel.slug, timestamp: timestamp, mainText: channel.title, subText: String(channel.length), imageUrl: ""), at: 0)
                                        })
                                    }
                                } else if selection.rawValue == "Users" {
                                    ForEach(exploreResults.users, id: \.id) { user in
                                        NavigationLink(destination: UserView(userId: user.id)) {
                                            UserPreview(user: user)
                                        }
                                        .onAppear {
                                            if exploreResults.users.count >= 8 {
                                                if exploreResults.users[exploreResults.users.count - 8].id == user.id {
                                                    exploreData.loadMore()
                                                }
                                            }
                                        }
                                        .simultaneousGesture(TapGesture().onEnded{
                                            AddUserToRabbitHole(user: user)
                                        })
                                    }
                                }
                            }
                        }
                        
                        if exploreData.isLoading {
                            CircleLoadingSpinner()
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .coordinateSpace(name: "scroll")
                } else if exploreData.isLoading {
                    CircleLoadingSpinner()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .refreshable {
                do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                exploreData.refresh()
            }
            .onChange(of: selection, initial: true) { oldSelection, newSelection in
                if oldSelection != newSelection {
                    exploreData.selection = newSelection.rawValue
                    exploreData.isLoading = false
                    exploreData.refresh()
                }
            }
            .padding(.bottom, 4)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Explore")
                        .foregroundStyle(Color("text-primary"))
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Select a display mode", selection: $selection) {
                            ForEach(selectionOptions, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    } label: {
                        selectionLabel
                    }
                    .foregroundStyle(Color("surface-text-secondary"))
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(selection.rawValue == "Blocks" ? 8 : 16)
    }
}

#Preview {
    ExploreView()
}
