//
//  ChannelsView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import Defaults
import Combine

struct PinnedChannelsView: View {
    @StateObject private var pinnedChannelsData: PinnedChannelsData
    @Default(.pinnedChannels) var pinnedChannels
    @Default(.pinnedChannelsChanged) var pinnedChannelsChanged
    
    init() {
        self._pinnedChannelsData = StateObject(wrappedValue: PinnedChannelsData(pinnedChannels: Defaults[.pinnedChannels]))
    }
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                if pinnedChannels.isEmpty {
                    InitialPinnedChannels()
                } else if pinnedChannelsData.isLoading {
                    CircleLoadingSpinner()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(pinnedChannelsData.channels ?? [], id: \.id) { channel in
                                ChannelCard(channel: channel, showPin: false)
                                    .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 32))
                                    .contextMenu {
                                        Button {
                                            Defaults[.connectSheetOpen] = true
                                            Defaults[.connectItemId] = channel.id
                                            Defaults[.connectItemType] = "Channel"
                                        } label: {
                                            Label("Connect", systemImage: "arrow.right")
                                        }
                                        
                                        Button {
                                            removePinnedChannel(channel.id)
                                            Defaults[.toastMessage] = "Unpinned!"
                                            Defaults[.showToast] = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                Defaults[.showToast] = false
                                            }
                                        } label: {
                                            Label(pinnedChannels.contains(channel.id) ? "Remove bookmark" : "Bookmark", systemImage: pinnedChannels.contains(channel.id) ? "bookmark.fill" : "bookmark")
                                        }
                                    }
                            }
                        }
                        
                    }
                    .padding(.bottom, 4)
                    .refreshable {
                        do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                        pinnedChannelsData.refresh(pinnedChannels: Defaults[.pinnedChannels])
                    }
                }
            }
            .onAppear {
                if pinnedChannelsChanged {
                    pinnedChannelsData.fetchChannels(pinnedChannels: Defaults[.pinnedChannels], refresh: true)
                    Defaults[.pinnedChannelsChanged] = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Bookmarks")
                        .foregroundStyle(Color("text-primary"))
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("background"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color("background"))
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
    
    private func removePinnedChannel(_ channelId: Int) {
        // If the channel is pinned, remove it from the view without refetching data
        if let index = pinnedChannelsData.channels?.firstIndex(where: { $0.id == channelId }) {
            var updatedChannels = pinnedChannelsData.channels ?? []
            updatedChannels.remove(at: index)
            pinnedChannelsData.channels = updatedChannels
        }
        
        pinnedChannels.removeAll { $0 == channelId }
    }
}

#Preview {
    PinnedChannelsView()
}
