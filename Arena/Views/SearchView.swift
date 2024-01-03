//
//  SearchChannels.swift
//  Arena
//
//  Created by Yihui Hu on 19/10/23.
//

import SwiftUI
import SmoothGradient
import NukeUI
import Defaults

struct SearchView: View {
    @StateObject private var searchData: SearchData
    @StateObject private var exploreData: ExploreData
    @FocusState private var searchInputIsFocused: Bool
    @State private var searchTerm: String = ""
    @State private var selection: String = "Blocks"
    @State private var changedSelection: Bool = false
    @State private var isButtonFaded = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showGradient = false
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init() {
        self._searchData = StateObject(wrappedValue: SearchData())
        self._exploreData = StateObject(wrappedValue: ExploreData())
    }
    
    var body: some View {
        let options = ["Blocks", "Channels", "Users"]
        let gridGap: CGFloat = 8
        let gridSpacing = gridGap + 8
        let gridColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: gridGap), count: 2)
        let displayWidth = UIScreen.main.bounds.width
        let gridItemSize = (displayWidth - (gridGap * 3) - 16) / 2
        
        NavigationStack {
            VStack {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        TextField("Search...", text: $searchTerm)
                            .onChange(of: searchTerm) { _, newValue in
                                if newValue == "" {
                                    searchData.searchResults = nil
                                }
                            }
                            .textFieldStyle(SearchBarStyle())
                            .autocorrectionDisabled()
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .always
                            }
                            .focused($searchInputIsFocused)
                            .onSubmit {
                                searchData.searchTerm = searchTerm
                                searchData.refresh()
                            }
                            .submitLabel(.search)
                        
                        if searchInputIsFocused {
                            Button(action: {
                                searchInputIsFocused = false
                            }) {
                                Text("Cancel")
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(Color("text-secondary"))
                            }
                        }
                    }
                    .animation(.bouncy(duration: 0.3), value: UUID())
                    
                    HStack(spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selection = option
                            }) {
                                Text("\(option)")
                                    .foregroundStyle(Color(selection == option ? "background" : "surface-text-secondary"))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(selection == option ? "text-primary" : "surface"))
                            .cornerRadius(16)
                        }
                        .opacity(isButtonFaded ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.1)) {
                                isButtonFaded = true
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                if let searchResults = searchData.searchResults, searchTerm != "" {
                    ZStack {
//                        GeometryReader { geometry in
//                            LinearGradient(
//                                gradient: .smooth(from: Color("background"), to: Color("background").opacity(0), curve: .easeInOut),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                            .frame(height: 88)
//                            .position(x: geometry.size.width / 2, y: 44)
//                            .opacity(showGradient ? 1 : 0)
//                            .animation(.easeInOut(duration: 0.2), value: UUID())
//                        }
//                        .allowsHitTesting(false) // Allows items underneath to be tapped
//                        .zIndex(2)
                        
                        ScrollView {
                            ScrollViewReader { proxy in
                                if selection == "Blocks" {
                                    LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                                        ForEach(Array(zip(searchResults.blocks.indices, searchResults.blocks)), id: \.0) { _, block in
                                            NavigationLink(destination: SingleBlockView(block: block)) {
                                                VStack(spacing: 8) {
                                                    ChannelViewBlockPreview(blockData: block, fontSize: 12, display: "Grid", isContextMenuPreview: false)
                                                        .frame(width: gridItemSize, height: gridItemSize)
                                                        .background(Color("background"))
                                                        .contextMenu {
                                                            Button {
                                                                Defaults[.connectSheetOpen] = true
                                                                Defaults[.connectItemId] = block.id
                                                                Defaults[.connectItemType] = "Block"
                                                            } label: {
                                                                Label("Connect", systemImage: "arrow.right")
                                                            }
                                                            
                                                            NavigationLink(destination: SingleBlockView(block: block)) {
                                                                Label("View", systemImage: "eye")
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
                                                    if searchResults.blocks.count >= 8 {
                                                        if searchResults.blocks[searchResults.blocks.count - 8].id == block.id {
                                                            searchData.loadMore()
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
                                        if selection == "Channels" {
                                            ForEach(searchResults.channels, id: \.id) { channel in
                                                NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                                    SearchChannelPreview(channel: channel)
                                                }
                                                .onAppear {
                                                    if searchResults.channels.last?.id ?? -1 == channel.id {
                                                        if !searchData.isLoading {
                                                            searchData.loadMore()
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
                                        } else if selection == "Users" {
                                            ForEach(searchResults.users, id: \.id) { user in
                                                NavigationLink(destination: UserView(userId: user.id)) {
                                                    UserPreview(user: user)
                                                }
                                                .onAppear {
                                                    if searchResults.users.last?.id ?? -1 == user.id {
                                                        if !searchData.isLoading {
                                                            searchData.loadMore()
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
                            }
//                            .onChange(of: scrollOffset) { _, offset in
//                                withAnimation {
//                                    showGradient = offset > -4
//                                }
//                            }
//                            .background(GeometryReader { proxy -> Color in
//                                DispatchQueue.main.async {
//                                    scrollOffset = -proxy.frame(in: .named("scroll")).origin.y
//                                }
//                                return Color.clear
//                            })
                            
                            if searchData.isLoading, searchTerm != "" {
                                CircleLoadingSpinner()
                                    .padding(.vertical, 12)
                            }
                            
                            if selection == "Channels", searchResults.channels.isEmpty, !searchData.isLoading {
                                EmptySearch(items: "channels", searchTerm: searchData.searchTerm)
                            } else if selection == "Blocks", searchResults.blocks.isEmpty, !searchData.isLoading {
                                EmptySearch(items: "blocks", searchTerm: searchData.searchTerm)
                            } else if selection == "Users", searchResults.users.isEmpty, !searchData.isLoading {
                                EmptySearch(items: "users", searchTerm: searchData.searchTerm)
                            } else if searchData.currentPage > searchData.totalPages, searchTerm != "" {
                                EndOfSearch()
                            }
                        }
                        .scrollDismissesKeyboard(.immediately)
                        .coordinateSpace(name: "scroll")
                    }
                } else if searchData.isLoading, searchTerm != "" {
                    CircleLoadingSpinner()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    if let exploreResults = exploreData.exploreResults {
                        ZStack {
//                            GeometryReader { geometry in
//                                LinearGradient(
//                                    gradient: .smooth(from: Color("background"), to: Color("background").opacity(0), curve: .easeInOut),
//                                    startPoint: .top,
//                                    endPoint: .bottom
//                                )
//                                .frame(height: 88)
//                                .position(x: geometry.size.width / 2, y: 44)
//                                .opacity(showGradient ? 1 : 0)
//                                .animation(.easeInOut(duration: 0.2), value: UUID())
//                            }
//                            .allowsHitTesting(false) // Allows items underneath to be tapped
//                            .zIndex(2)
                            
                            ScrollView {
                                ScrollViewReader { proxy in
                                    if selection == "Blocks" {
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
                                            if selection == "Channels" {
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
                                            } else if selection == "Users" {
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
//                                .onChange(of: scrollOffset) { _, offset in
//                                    withAnimation {
//                                        showGradient = offset > -4
//                                    }
//                                }
//                                .background(GeometryReader { proxy -> Color in
//                                    DispatchQueue.main.async {
//                                        scrollOffset = -proxy.frame(in: .named("explore-scroll")).origin.y
//                                    }
//                                    return Color.clear
//                                })
                            }
                            .refreshable {
                                do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                                exploreData.refresh()
                            }
                            .scrollDismissesKeyboard(.immediately)
                            .coordinateSpace(name: "explore-scroll")
                        }
                    } else if exploreData.isLoading {
                        CircleLoadingSpinner()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
            }
            .padding(.bottom, 4)
            .onChange(of: selection, initial: true) { oldSelection, newSelection in
                if oldSelection != newSelection {
                    searchData.selection = newSelection
                    searchData.isLoading = false
                    searchData.refresh()
                }
            }
            .onChange(of: selection, initial: true) { oldSelection, newSelection in
                if oldSelection != newSelection {
                    exploreData.selection = newSelection
                    exploreData.isLoading = false
                    exploreData.refresh()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(.horizontal, 16)
        .contentMargins(.bottom, 16)
    }
}

struct SearchChannelPreview: View {
    let channel: ArenaSearchedChannel
    @Default(.pinnedChannels) var pinnedChannels
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    if channel.status != "closed" {
                        Image(systemName: "circle.fill")
                            .scaleEffect(0.5)
                            .foregroundColor(channel.status == "public" ? Color.green : Color.red)
                    }
                    
                    Text("\(channel.title)")
                        .foregroundStyle(Color("text-primary"))
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                if (pinnedChannels.contains(channel.id)) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(Color("surface-text-secondary"))
                        .imageScale(.small)
                }
            }
            
            Text("\(channel.user.username) • \(channel.length) items")
                .font(.system(size: 14))
                .lineLimit(1)
                .foregroundStyle(Color("surface-text-secondary"))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color("surface"))
        .cornerRadius(16)
        .contentShape(ContentShapeKinds.contextMenuPreview, RoundedRectangle(cornerRadius: 16))
        .contextMenu {
            Button {
                Defaults[.connectSheetOpen] = true
                Defaults[.connectItemId] = channel.id
                Defaults[.connectItemType] = "Channel"
            } label: {
                Label("Connect", systemImage: "arrow.right")
            }
            
            Button {
                togglePin(channel.id)
            } label: {
                Label(pinnedChannels.contains(channel.id) ? "Unpin" : "Pin", systemImage: pinnedChannels.contains(channel.id) ? "heart.fill" : "heart")
            }
        }
    }
    
    private func togglePin(_ channelId: Int) {
        if Defaults[.pinnedChannels].contains(channelId) {
            Defaults[.pinnedChannels].removeAll { $0 == channelId }
            Defaults[.toastMessage] = "Unpinned!"
        } else {
            Defaults[.pinnedChannels].append(channelId)
            Defaults[.toastMessage] = "Pinned!"
        }
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
        Defaults[.pinnedChannelsChanged] = true
    }
}

#Preview {
    SearchView()
}
