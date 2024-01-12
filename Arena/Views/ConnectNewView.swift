//
//  ConnectNewView.swift
//  Arena
//
//  Created by Yihui Hu on 12/12/23.
//

import SwiftUI
import Defaults

struct ConnectNewView: View {
    @StateObject var channelsData: ChannelsData
    @StateObject private var channelSearchData: SearchData
    @FocusState private var searchInputIsFocused: Bool
    
    @State private var searchTerm: String = ""
    @State private var selection: String = "Channels"
    @State private var channelsToConnect: [String] = []
    @State private var isConnecting: Bool = false
    
    @Binding var imageData: [Data]
    @Binding var textData: String
    @Binding var linkData: [String]
    @Binding var titleData: [String]
    @Binding var descriptionData: [String]
    
    @Environment(\.dismiss) private var dismiss
    
    init(imageData: Binding<[Data]>, textData: Binding<String>, linkData: Binding<[String]>, titleData: Binding<[String]>, descriptionData: Binding<[String]>) {
        self._channelSearchData = StateObject(wrappedValue: SearchData())
        self._channelsData = StateObject(wrappedValue: ChannelsData(userId: Defaults[.userId]))
        self._imageData = imageData
        self._textData = textData
        self._linkData = linkData
        self._titleData = titleData
        self._descriptionData = descriptionData
    }
    
    var body: some View {
        let userChannels = channelsData.channels?.channels ?? []
        
        VStack(spacing: 0) {
            // Search input
            HStack(spacing: 12) {
                TextField("Search...", text: $searchTerm)
                    .onChange(of: searchTerm) { _, newValue in
                        if newValue == "" {
                            channelSearchData.searchResults = nil
                        }
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
                            channelSearchData.selection = "Channels"
                            channelSearchData.searchTerm = searchTerm
                            channelSearchData.refresh()
                        }
                    }
                    .submitLabel(.search)
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
                        Defaults[.connectedItem] = true
                        
                        if !(imageData.isEmpty) {
                            Task {
                                await connectImagesToChannel(channels: channelsToConnect, selectedPhotosData: imageData, titles: titleData, descriptions: descriptionData) {
                                    isConnecting = false
                                    channelsToConnect = []
                                }
                            }
                        } else if !(textData.isEmpty) {
                            Task {
                                await connectTextToChannel(channels: channelsToConnect, text: textData, title: titleData, description: descriptionData) {
                                    isConnecting = false
                                    channelsToConnect = []
                                }
                            }
                        } else if !(linkData.isEmpty) {
                            Task {
                                await connectLinksToChannel(channels: channelsToConnect, links: linkData, title: titleData, description: descriptionData) {
                                    isConnecting = false
                                    channelsToConnect = []
                                }
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
        .padding(.bottom, 4)
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
        }
        .toolbarBackground(Color("background"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
