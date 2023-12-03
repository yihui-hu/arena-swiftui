//
//  SearchChannels.swift
//  Arena
//
//  Created by Yihui Hu on 19/10/23.
//

import SwiftUI
import DebouncedOnChange
import SmoothGradient
import NukeUI
import Defaults

struct SearchView: View {
    @StateObject private var searchData: SearchData
    @FocusState private var searchInputIsFocused: Bool
    @State private var searchTerm: String = ""
    @State private var selection: String = "Channels"
    @State private var changedSelection: Bool = false
    @State private var isButtonFaded = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showGradient = false
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init() {
        self._searchData = StateObject(wrappedValue: SearchData())
    }
    
    var body: some View {
        let options = ["Channels", "Blocks", "Users"]
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
                            .onChange(of: searchTerm, debounceTime: .seconds(0.5)) { newValue in
                                searchData.searchTerm = newValue
                                searchData.refresh()
                            }
                            .textFieldStyle(SearchBarStyle())
                            .autocorrectionDisabled()
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .always
                            }
                            .focused($searchInputIsFocused)
                            .onSubmit {
                                if !(searchData.isLoading) {
                                    searchData.searchTerm = searchTerm
                                    searchData.refresh()
                                }
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
                    .animation(.bouncy(duration: 0.2), value: UUID())
                    
                        HStack(spacing: 8) {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selection = option
                                }) {
                                    Text("\(option)")
                                        .foregroundStyle(selection == option ? Color("background") : Color("surface-text-secondary"))
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
                .padding(.bottom, 4)
                
                if let searchResults = searchData.searchResults, searchTerm != "" {
                    ZStack {
                        GeometryReader { geometry in
                            LinearGradient(
                                gradient: .smooth(from: Color("background"), to: Color("background").opacity(0), curve: .easeInOut),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 88)
                            .position(x: geometry.size.width / 2, y: 44)
                            .opacity(showGradient ? 1 : 0)
                            .animation(.easeInOut(duration: 0.2), value: UUID())
                        }
                        .allowsHitTesting(false) // Allows items underneath to be tapped
                        .zIndex(2)
                        
                        ScrollView {
                            ScrollViewReader { proxy in
                                if selection == "Blocks" {
                                    LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                                        ForEach(Array(zip(searchResults.blocks.indices, searchResults.blocks)), id: \.0) { _, block in
                                            NavigationLink(destination: SingleBlockView(block: block)) {
                                                VStack(spacing: 8) {
                                                    ChannelViewBlockPreview(blockData: block, fontSize: 12, display: "Grid")
                                                        .frame(width: gridItemSize, height: gridItemSize)
                                                        .background(Color("background"))
                                                        .contextMenu {
                                                            Button {
                                                                // Do something
                                                            } label: {
                                                                Label("Connect", systemImage: "arrow.right")
                                                            }
                                                            
                                                            NavigationLink(destination: SingleBlockView(block: block)) {
                                                                Label("View", systemImage: "eye")
                                                            }
                                                        } preview: {
                                                            let img = block.image
                                                            if img != nil {
                                                                ChannelViewBlockPreview(blockData: block, fontSize: 16, display: "Feed")
                                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                            } else {
                                                                ChannelViewBlockPreview(blockData: block, fontSize: 18, display: "Feed")
                                                                    .padding(32)
                                                                    .frame(width: 400, height: 400)
                                                            }
                                                        }
                                                    
                                                    ContentPreviewMetadata(block: block, display: "Grid")
                                                        .padding(.horizontal, 12)
                                                }
                                                .onAppear {
                                                    if searchResults.blocks.last?.id ?? -1 == block.id {
                                                        if !searchData.isLoading {
                                                            searchData.loadMore()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    LazyVStack(alignment: .leading, spacing: 8) {
                                        if selection == "Channels" {
                                            ForEach(searchResults.channels, id: \.id) { channel in
                                                NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                                    SearchChannelPreview(channel: channel, pinnedChannels: $pinnedChannels)
                                                }
                                                .onAppear {
                                                    if searchResults.channels.last?.id ?? -1 == channel.id {
                                                        if !searchData.isLoading {
                                                            searchData.loadMore()
                                                        }
                                                    }
                                                }
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
                                            }
                                        }
                                    }
                                }
                            }
                            .onChange(of: scrollOffset) { _, offset in
                                withAnimation {
                                    showGradient = offset > -4
                                }
                            }
                            .background(GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    scrollOffset = -proxy.frame(in: .named("scroll")).origin.y
                                }
                                return Color.clear
                            })
                            
                            if searchData.isLoading, searchTerm != "" {
                                CircleLoadingSpinner()
                                    .padding(.vertical, 12)
                            }
                            
                            if selection == "Channels", searchResults.channels.isEmpty {
                                EmptySearch(items: "channels", searchTerm: searchTerm)
                            } else if selection == "Blocks", searchResults.blocks.isEmpty {
                                EmptySearch(items: "blocks", searchTerm: searchTerm)
                            } else if selection == "Users", searchResults.users.isEmpty {
                                EmptySearch(items: "users", searchTerm: searchTerm)
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
                    InitialSearch()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onTapGesture {
                            searchInputIsFocused = false
                        }
                        .gesture(DragGesture().onEnded { value in
                            if value.translation.height > 50 {
                                searchInputIsFocused = false
                            }
                        })
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
}

struct SearchChannelPreview: View {
    let channel: ArenaSearchedChannel
    @Binding var pinnedChannels: [Int]
    
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
                        .foregroundStyle(Color.primary)
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                if (pinnedChannels.contains(channel.id)) {
                    Image(systemName: "pin.fill")
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
                togglePin(channel.id)
            } label: {
                Label(pinnedChannels.contains(channel.id) ? "Unpin" : "Pin", systemImage: pinnedChannels.contains(channel.id) ? "pin.slash.fill" : "pin.fill")
            }
        }
    }
    
    private func togglePin(_ channelId: Int) {
        if pinnedChannels.contains(channelId) {
            pinnedChannels.removeAll { $0 == channelId }
        } else {
            pinnedChannels.append(channelId)
        }
        Defaults[.pinnedChannelsChanged] = true
    }
}

struct SearchBarStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.vertical, 12)
            .foregroundColor(Color("text-primary"))
            .background(Color("surface"))
            .cornerRadius(50)
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .tint(Color.primary)
    }
}

#Preview {
    SearchView()
}
