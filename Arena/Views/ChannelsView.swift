//
//  ChannelsView.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import SwiftUI
import CachedAsyncImage

struct ChannelsView: View {
    @StateObject var channelsData = ChannelsData()
    @State private var selectedChannelSlug: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(channelsData.channels?.channels ?? [], id: \.self.id) { channel in
                        ChannelCard(channel: channel)
                            .onBecomingVisible {
                                if let channels = channelsData.channels?.channels, channels.count >= 8 {
                                    if channels[channels.count - 8].id == channel.id {
                                        Task {
                                            do {
                                                try await channelsData.loadMore()
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                    
                    if channelsData.isLoading {
                        LoadingSpinner()
                    }
                    
                    if channelsData.currentPage > channelsData.totalPages {
                        Text("Finished loading all channels")
                            .padding(.top, 24)
                            .foregroundStyle(Color("surface-text-secondary"))
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
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
        .refreshable {
            do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
            do { try await channelsData.refresh() } catch { print(error) }
        }
    }
}

#Preview {
    ChannelsView()
}
