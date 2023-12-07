//
//  ConnectView.swift
//  Arena
//
//  Created by Yihui Hu on 6/12/23.
//

import SwiftUI
import Defaults
import SwiftUIX

struct ConnectExistingView: View {
    @StateObject var channelsData: ChannelsData
    @StateObject private var channelSearchData: SearchData
    @FocusState private var searchInputIsFocused: Bool
    
    @State private var itemId: Int
    @State private var type: String
    @State private var searchTerm: String = ""
    @State private var selection: String = "Channels"
    @State private var channelsToConnect: [String] = []
    @State private var isConnecting: Bool = false
    
    init(itemId: Int, type: String) {
        self._channelSearchData = StateObject(wrappedValue: SearchData())
        self._channelsData = StateObject(wrappedValue: ChannelsData(userId: Defaults[.userId]))
        self.itemId = itemId
        self.type = type
    }
    
    var body: some View {
        let userChannels = channelsData.channels?.channels ?? []
        
        VStack(spacing: 0) {
            // Search input
            HStack(spacing: 12) {
                TextField("Search...", text: $searchTerm)
                    .onChange(of: searchTerm, debounceTime: .seconds(0.5)) { newValue in
                        channelSearchData.searchTerm = newValue
                        channelSearchData.refresh()
                    }
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(SearchBarStyle())
                    .autocorrectionDisabled()
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .always
                    }
                    .focused($searchInputIsFocused)
                    .onSubmit {
                        if !(channelSearchData.isLoading) {
                            channelSearchData.searchTerm = searchTerm
                            channelSearchData.refresh()
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
                
                if !(channelsToConnect.isEmpty), !searchInputIsFocused {
                    Button(action: {
                        isConnecting = true
                        
                        Task {
                            await connectToChannel(channels: channelsToConnect, id: itemId , type: type) {
                                isConnecting = false
                                channelsToConnect = []
                            }
                        }
                    }) {
                        if isConnecting {
                            CircleLoadingSpinner(customColor: "background", customBgColor: "surface")
                        } else {
                            Text("Connect")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(Color("background"))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color("text-primary"))
                    .cornerRadius(64)
                    .disabled(isConnecting)
                }
            }
            .animation(.bouncy(duration: 0.3), value: UUID())
            .padding(16)
            
            // List of channels
            ScrollView {
                LazyVStack(spacing: 0) {
                    if let searchResults = channelSearchData.searchResults, searchTerm != "" {
                        ForEach(searchResults.channels, id: \.id) { channel in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    if channelsToConnect.contains(channel.slug) {
                                        channelsToConnect.removeAll { $0 == channel.slug }
                                    } else {
                                        channelsToConnect.append(channel.slug)
                                    }
                                }
                            }) {
                                SmallChannelPreview(channel: channel)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(channelsToConnect.contains(channel.slug) ? "surface-text-secondary" : "clear"), lineWidth: 2)
                                    )
                                    .padding(.bottom, 8)
                                    .onBecomingVisible {
                                        if searchResults.channels.last?.id ?? -1 == channel.id {
                                            if !channelSearchData.isLoading {
                                                channelSearchData.loadMore()
                                            }
                                        }
                                    }
                            }
                            .buttonStyle(ConnectChannelButtonStyle())
                        }
                        
                        if channelSearchData.isLoading, searchTerm != "" {
                            CircleLoadingSpinner()
                                .padding(.vertical, 12)
                        }
                        
                        if searchResults.channels.isEmpty {
                            EmptySearch(items: "channels", searchTerm: searchTerm)
                        } else if channelSearchData.currentPage > channelSearchData.totalPages, searchTerm != "" {
                            EndOfSearch()
                        }
                    } else if channelSearchData.isLoading, searchTerm != "" {
                        CircleLoadingSpinner()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding(.top, 64)
                    } else {
                        if !channelsData.isLoading, userChannels.isEmpty {
                            EmptyUserChannels()
                        } else {
                            ForEach(Array(zip(userChannels.indices, userChannels)), id: \.0) { _, channel in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        if channelsToConnect.contains(channel.slug) {
                                            channelsToConnect.removeAll { $0 == channel.slug }
                                        } else {
                                            channelsToConnect.append(channel.slug)
                                        }
                                    }
                                }) {
                                    SmallChannelPreviewUser(channel: channel)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(channelsToConnect.contains(channel.slug) ? "surface-text-secondary" : "clear"), lineWidth: 2)
                                        )
                                        .padding(.bottom, 8)
                                        .onBecomingVisible {
                                            if userChannels.count >= 1 {
                                                if userChannels[userChannels.count - 1].id == channel.id {
                                                    channelsData.loadMore(userId: Defaults[.userId])
                                                }
                                            }
                                        }
                                }
                                .buttonStyle(ConnectChannelButtonStyle())
                            }
                            
                            if channelsData.isLoading {
                                CircleLoadingSpinner()
                                    .padding(.vertical, 12)
                            }
                            
                            if channelsData.currentPage > channelsData.totalPages {
                                EndOfUser()
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .contentMargins(.top, 1)
        .contentMargins(.top, -1, for: .scrollIndicators)
    }
}

