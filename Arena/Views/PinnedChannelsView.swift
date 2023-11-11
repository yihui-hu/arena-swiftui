//
//  ChannelsView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Defaults

struct PinnedChannelsView: View {
    @ObservedObject private var pinnedChannelsData = PinnedChannelsData()
    @Default(.pinnedChannels) var pinnedChannels

    var body: some View {
        NavigationStack {
            if pinnedChannelsData.pinnedChannels.isEmpty {
                VStack(alignment: .center) {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.folder.fill")
                        Text("No pinned channels")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .contentMargins(.bottom, 88)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Pinned")
                            .font(.system(size: 20))
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }
                .toolbarBackground(Color("background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("background"))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(pinnedChannelsData.channels ?? [], id: \.id) { channel in
                            ChannelCard(channel: channel)
                                .onAppear {
                                    if let channels = pinnedChannelsData.channels, channels.count >= 2 {
                                        if channels[channels.count - 2].id == channel.id {
                                            pinnedChannelsData.loadMore()
                                        }
                                    }
                                }
                                .contextMenu {
                                    Button {
                                        togglePin(channel.id)
                                    } label: {
                                        Label(pinnedChannels.contains(channel.id) ? "Unpin" : "Pin", systemImage: pinnedChannels.contains(channel.id) ? "pin.slash.fill" : "pin.fill")
                                    }
                                }
                        }
                    }
                }
                .contentMargins(.bottom, 88)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Pinned")
                            .font(.system(size: 20))
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }
                .toolbarBackground(Color("background"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .background(Color("background"))
            }
        }
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
    
    private func togglePin(_ channelId: Int) {
        if pinnedChannels.contains(channelId) {
            pinnedChannels.removeAll { $0 == channelId }
        } else {
            pinnedChannels.append(channelId)
        }
    }
}

#Preview {
    PinnedChannelsView()
}
