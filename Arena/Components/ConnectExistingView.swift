//
//  ConnectExistingView.swift
//  Arena
//
//  Created by Yihui Hu on 6/12/23.
//

import SwiftUI
import Defaults
import DebouncedOnChange

struct ConnectExistingView: View {
    @StateObject var channelsData: ChannelsData
    @StateObject private var channelSearchData: SearchData
    @FocusState private var searchInputIsFocused: Bool
    
    @State private var searchTerm: String = ""
    @State private var channelsToConnect: [String] = []
    @State private var isConnecting: Bool = false
    
    init() {
        self._channelSearchData = StateObject(wrappedValue: SearchData())
        self._channelsData = StateObject(wrappedValue: ChannelsData(userId: Defaults[.userId]))
    }
    
    var body: some View {
        let userChannels = channelsData.channels?.channels ?? []
        
        VStack(spacing: 0) {
            // Search input
            HStack(spacing: 12) {
                TextField("Search...", text: $searchTerm)
                    .onChange(of: searchTerm, debounceTime: .seconds(0.5)) { newValue in
                        channelSearchData.selection = "Channels"
                        if newValue == "" {
                            channelSearchData.searchResults = nil
                        } else {
                            channelSearchData.searchTerm = newValue
                            channelSearchData.refresh()
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(ConnectSearchBarStyle())
                    .autocorrectionDisabled()
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .always
                    }
                    .focused($searchInputIsFocused)
                    .onSubmit {
                        if !channelSearchData.isLoading, searchTerm != channelSearchData.searchTerm {
                            channelSearchData.selection = "Channels"
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
                            await connectToChannel(channels: channelsToConnect, id: Defaults[.connectItemId] , type: Defaults[.connectItemType]) {
                                isConnecting = false
                                channelsToConnect = []
                            }
                        }
                        Defaults[.connectedItem] = true
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
                    .padding(.horizontal, isConnecting ? 12 : 16)
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
                                searchInputIsFocused = false
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
                                            .stroke(channelsToConnect.contains(channel.slug) ? Color("surface-text-secondary") : Color.clear, lineWidth: 2)
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
                            EmptySearch(items: "channels", searchTerm: channelSearchData.searchTerm)
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
                                    searchInputIsFocused = false
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
                                                .stroke(channelsToConnect.contains(channel.slug) ? Color("surface-text-secondary") : Color.clear, lineWidth: 2)
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
                                    .padding(.top, 16)
                                    .padding(.bottom, 12)
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

