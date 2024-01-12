//
//  ChannelView.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import SwiftUI
import WrappingHStack
import Defaults
import UniformTypeIdentifiers

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
}

enum ContentOption: String, CaseIterable {
    case all = "All"
    //    case blocks = "Blocks"
    //    case channels = "Channels"
    case connections = "Connections"
}

struct ChannelView: View {
    @StateObject private var channelData: ChannelData
    @StateObject private var channelConnectionsData: ChannelConnectionsData
    let channelSlug: String
    
    @State private var selection = SortOption.position
    @State private var display = DisplayOption.grid
    @State private var content = ContentOption.all
    @State private var channelPinned = false
    @State private var clickedPin = false
    @State private var showingConnections = false
    let sortOptions = SortOption.allCases
    let displayOptions = DisplayOption.allCases
    let contentOptions = ContentOption.allCases
    
    @Environment(\.dismiss) private var dismiss
    
    init(channelSlug: String) {
        self.channelSlug = channelSlug
        self._channelData = StateObject(wrappedValue: ChannelData(channelSlug: channelSlug, selection: SortOption.position))
        self._channelConnectionsData = StateObject(wrappedValue: ChannelConnectionsData(channelSlug: channelSlug))
    }
    
    var displayLabel: some View {
        switch display {
        case .grid:
            return Image(systemName: "square.grid.2x2")
                .resizable()
                .scaledToFit()
                .fontWeight(.semibold)
                .frame(width: 18, height: 18)
        case .largeGrid:
            return Image(systemName: "square.grid.3x3")
                .resizable()
                .scaledToFit()
                .fontWeight(.semibold)
                .frame(width: 18, height: 18)
        case .table:
            return Image(systemName: "rectangle.grid.1x2")
                .resizable()
                .scaledToFit()
                .fontWeight(.semibold)
                .frame(width: 18, height: 18)
        case .feed:
            return Image(systemName: "square")
                .resizable()
                .scaledToFit()
                .fontWeight(.semibold)
                .frame(width: 18, height: 18)
        }
    }
    
    @ViewBuilder
    private func destinationView(for block: Block, channelData: ChannelData, channelSlug: String) -> some View {
        if block.baseClass == "Block" {
            BlockView(blockData: block, channelData: channelData, channelSlug: channelSlug)
        } else {
            ChannelView(channelSlug: block.slug ?? "")
        }
    }
    
    @ViewBuilder
    private func ChannelViewContents(gridItemSize: CGFloat) -> some View {
        ForEach(channelData.contents ?? [], id: \.self.id) { block in
            NavigationLink(destination: destinationView(for: block, channelData: channelData, channelSlug: channelSlug)) {
                ChannelContentPreview(block: block, channelData: channelData, channelSlug: channelSlug, gridItemSize: gridItemSize, display: display.rawValue)
            }
            .onAppear {
                loadMoreChannelData(channelData: channelData, channelSlug: self.channelSlug, block: block)
            }
            .simultaneousGesture(TapGesture().onEnded{
                let id = UUID()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm, d MMM y"
                let timestamp = formatter.string(from: Date.now)
                if block.baseClass == "Block" {
                    AddBlockToRabbitHole(block: block)
                } else {
                    Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "channel", subtype: block.status ?? "", itemId: block.slug ?? "", timestamp: timestamp, mainText: block.title, subText: String(block.length ?? 0), imageUrl: String(block.id)), at: 0)
                }
            })
        }
    }
    
    var body: some View {
        // Setting up grid
        let gridGap: CGFloat = 8
        let gridSpacing = display.rawValue != "Large Grid" ? gridGap + 8 : gridGap
        let gridColumns: [GridItem] =
        Array(repeating:
                .init(.flexible(), spacing: gridGap),
              count:
                display.rawValue == "Grid" ? 2 :
                display.rawValue == "Large Grid" ? 3 :
                1)
        let displayWidth = UIScreen.main.bounds.width
        let gridItemSize =
        display.rawValue == "Grid" ? (displayWidth - (gridGap * 3)) / 2 :
        display.rawValue == "Large Grid" ? (displayWidth - (gridGap * 4)) / 3 :
        (displayWidth - (gridGap * 2))
        let channelCreator = channelData.channel?.user.slug ?? ""
        let channelId = channelData.channel?.id ?? 0
        
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ZStack {}.id(0) // Hacky implementation of scroll to top when switching sorting option
                    
                    ChannelViewHeader(channelData: channelData, content: $content, showingConnections: $showingConnections, contentOptions: contentOptions)
                    
                    if showingConnections {
                        if !channelConnectionsData.isLoading, channelConnectionsData.channelConnections.isEmpty {
                            EmptyChannelConnections()
                        } else {
                            ForEach(channelConnectionsData.channelConnections, id: \.id) { channel in
                                NavigationLink(destination: ChannelView(channelSlug: channel.slug)) {
                                    SearchChannelPreview(channel: channel)
                                }
                                .onBecomingVisible {
                                    if channelConnectionsData.channelConnections.last?.id ?? -1 == channel.id {
                                        if !channelConnectionsData.isLoading {
                                            channelConnectionsData.loadMore(channelSlug: self.channelSlug)
                                        }
                                    }
                                }
                                .simultaneousGesture(TapGesture().onEnded{
                                    let id = UUID()
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm, d MMM y"
                                    let timestamp = formatter.string(from: Date.now)
                                    Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "channel", subtype: channel.status, itemId: channel.slug, timestamp: timestamp, mainText: channel.title, subText: String(channel.length), imageUrl: String(channel.id)), at: 0)
                                })
                            }
                            
                            if channelConnectionsData.isLoading {
                                CircleLoadingSpinner()
                                    .padding(.top, 24)
                                    .padding(.bottom, 72)
                            }
                            
                            if channelConnectionsData.currentPage > channelConnectionsData.totalPages {
                                EndOfChannelConnections()
                                    .padding(.bottom, 72)
                            }
                        }
                    } else {
                        if display.rawValue == "Table" {
                            LazyVStack(spacing: 8) {
                                ChannelViewContents(gridItemSize: gridItemSize)
                            }
                        } else {
                            LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                                ChannelViewContents(gridItemSize: gridItemSize)
                            }
                        }
                        
                        if (channelData.isLoading || channelData.isContentsLoading) {
                            CircleLoadingSpinner()
                                .padding(.top, 24)
                                .padding(.bottom, 72)
                        }
                        
                        if let channelContents = channelData.contents, channelContents.isEmpty {
                            EmptyChannel()
                        } else if channelData.currentPage > channelData.totalPages {
                            EndOfChannel()
                                .padding(.bottom, 72)
                        }
                    }
                }
                .padding(.bottom, 4)
                .background(Color("background"))
                .contentMargins(gridGap)
                .contentMargins(.leading, 0, for: .scrollIndicators)
                .refreshable {
                    do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                    if showingConnections {
                        channelData.refresh(channelSlug: self.channelSlug, selection: selection)
                    } else {
                        channelConnectionsData.refresh(channelSlug: self.channelSlug)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            BackButton()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if !showingConnections {
                            HStack(spacing: 8) {
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
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .foregroundStyle(Color("surface-text-secondary"))
                        }
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
        .overlay(alignment: .bottom) {
            if channelId != 0 {
                HStack(spacing: 9) {
                    Menu {
                        Button(action: {
                            UIPasteboard.general.setValue(channelSlug as String,
                                                          forPasteboardType: UTType.plainText.identifier)
                            Defaults[.toastMessage] = "Copied!"
                            Defaults[.showToast] = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                Defaults[.showToast] = false
                            }
                        }) {
                            Label("Copy channel slug", systemImage: "clipboard")
                        }
                        
                        ShareLink(item: URL(string: "https://are.na/\(channelCreator)/\(channelSlug)")!) {
                            Label("Share channel", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.bold)
                            .imageScale(.small)
                            .foregroundStyle(Color("text-primary"))
                            .padding(.bottom, 4)
                            .frame(width: 40, height: 40)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                    
                    //                    ShareLink(item: URL(string: "https://are.na/\(channelCreator)/\(channelSlug)")!) {
                    //                        Image(systemName: "square.and.arrow.up")
                    //                            .fontWeight(.bold)
                    //                            .imageScale(.small)
                    //                            .foregroundStyle(Color("text-primary"))
                    //                            .padding(.bottom, 4)
                    //                            .frame(width: 40, height: 40)
                    //                            .background(.thinMaterial)
                    //                            .clipShape(Circle())
                    //                    }
                    
                    Button(action: {
                        Defaults[.connectSheetOpen] = true
                        Defaults[.connectItemId] = channelId
                        Defaults[.connectItemType] = "Channel"
                    }) {
                        Text("Connect")
                            .foregroundStyle(Color("text-primary"))
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.thinMaterial)
                    .cornerRadius(16)
                    
                    Button(action: {
                        togglePin(channelId)
                    }) {
                        Image(systemName: clickedPin ? channelPinned ? "bookmark.fill" : "bookmark" : Defaults[.pinnedChannels].contains(channelId) ? "bookmark.fill" : "bookmark")
                            .fontWeight(.bold)
                            .imageScale(.small)
                            .foregroundStyle(Color("text-primary"))
                            .frame(width: 40, height: 40)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }
    
    private func togglePin(_ channelId: Int) {
        clickedPin = true
        channelPinned = !(Defaults[.pinnedChannels].contains(channelId))
        
        if Defaults[.pinnedChannels].contains(channelId) {
            Defaults[.pinnedChannels].removeAll { $0 == channelId }
            Defaults[.toastMessage] = "Bookmark removed!"
        } else {
            Defaults[.pinnedChannels].append(channelId)
            Defaults[.toastMessage] = "Bookmarked!"
        }
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
        Defaults[.pinnedChannelsChanged] = true
    }
    
    private func loadMoreChannelData(channelData: ChannelData, channelSlug: String, block: Block) {
        if let contents = channelData.contents,
           contents.count >= 8,
           contents[contents.count - 8].id == block.id,
           !channelData.isContentsLoading {
            channelData.loadMore(channelSlug: channelSlug)
        }
    }
}

struct ChannelViewHeader: View {
    @StateObject var channelData: ChannelData
    @Binding var content: ContentOption
    @Binding var showingConnections: Bool
    @State var descriptionExpanded = false
    var contentOptions: [ContentOption]
    
    var body: some View {
        let channelTitle = channelData.channel?.title ?? ""
        let channelCreatedAt = channelData.channel?.createdAt ?? ""
        let channelCreated = dateFromString(string: channelCreatedAt)
        let channelUpdatedAt = channelData.channel?.updatedAt ?? ""
        let channelUpdated = relativeTime(channelUpdatedAt)
        let channelStatus = channelData.channel?.status ?? ""
        let channelDescription = channelData.channel?.metadata?.description ?? ""
        let channelOwner = channelData.channel?.user.fullName ?? ""
        //        let channelOwnerChannels = channelData.channel?.user.channelCount ?? 0
        let channelOwnerId = channelData.channel?.user.id ?? 0
        //        let channelOwnerImage = channelData.channel?.user.avatarImage.display ?? ""
        let channelCollaborators = channelData.channel?.collaborators ?? []
        
        VStack(spacing: 16) {
            // MARK: Channel Title / Dates
            HStack {
                if !channelTitle.isEmpty {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            if channelStatus != "closed" {
                                Image(systemName: "circle.fill")
                                    .scaleEffect(0.5)
                                    .foregroundColor(channelStatus == "public" ? Color.green : Color.red)
                            }
                            Text("\(channelTitle)")
                                .foregroundColor(Color("text-primary"))
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                        
                        Text("started ")
                            .foregroundColor(Color("text-secondary"))
                            .font(.system(size: 14)) +
                        Text(channelCreated, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                            .foregroundStyle(Color("text-secondary"))
                            .font(.system(size: 14)) +
                        Text(" • updated \(channelUpdated)")
                            .foregroundColor(Color("text-secondary"))
                            .font(.system(size: 14))
                    }
                } else {
                    VStack(spacing: 4) {
                        Text("loading...")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        Text("")
                    }
                }
            }
            .fontDesign(.rounded)
            .foregroundColor(Color("text-primary"))
            .lineLimit(2)
            .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                // MARK: Channel Description
                if !channelDescription.isEmpty {
                    Text(.init(channelDescription))
                        .tint(Color.primary)
                        .font(.system(size: 15))
                        .fontWeight(.regular)
                        .fontDesign(.default)
                        .foregroundColor(Color("text-secondary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(descriptionExpanded ? nil : 2)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                descriptionExpanded.toggle()
                            }
                        }
                        .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.4), trigger: descriptionExpanded)
                }
                
                // MARK: Channel Attribution
                if !channelOwner.isEmpty {
                    let ownerLink = NavigationLink(destination: UserView(userId: channelOwnerId)) {
                        Text("\(channelOwner)")
                            .foregroundColor(Color("text-primary"))
                    }
                        .simultaneousGesture(TapGesture().onEnded{
                            if channelData.channel != nil {
                                AddUserToRabbitHole(user: channelData.channel!.user)
                            }
                        })
                    
                    let collaboratorLinks = channelCollaborators.map { collaborator in
                        NavigationLink(destination: UserView(userId: collaborator.id)) {
                            Text("\(collaborator.fullName)")
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                                .foregroundColor(Color("text-primary"))
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            AddUserToRabbitHole(user: collaborator)
                        })
                    }
                    
                    WrappingHStack(alignment: .leading, horizontalSpacing: 4) {
                        Text("by")
                            .foregroundColor(Color("text-secondary"))
                        
                        ownerLink
                        
                        if !collaboratorLinks.isEmpty {
                            Text("with")
                                .foregroundColor(Color("text-secondary"))
                            ForEach(collaboratorLinks.indices, id: \.self) { index in
                                if index > 0 {
                                    Text("&")
                                        .foregroundColor(Color("text-secondary"))
                                }
                                collaboratorLinks[index]
                            }
                        }
                    }
                    .font(.system(size: 15))
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                } else {
                    Text("by ...")
                        .font(.system(size: 15))
                        .fontDesign(.default)
                        .fontWeight(.regular)
                        .foregroundColor(Color("text-secondary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
        }
        .padding(12)
        
        // MARK: Channel Content Options
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(contentOptions, id: \.self) { option in
                    Button(action: {
                        content = option
                        if option.rawValue == "Connections" {
                            showingConnections = true
                        } else {
                            showingConnections = false
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text("\(option.rawValue)")
                                .foregroundStyle(Color(content == option ? "background" : "surface-text-secondary"))
                            
                            if option.rawValue == "All", let channelLength = channelData.channel?.length {
                                Text("\(channelLength)")
                                    .foregroundStyle(Color(content == option ? "surface-text-secondary" : "surface-tertiary"))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(content == option ? "text-primary" : "surface"))
                    .cornerRadius(16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .font(.system(size: 15))
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, 4)
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

