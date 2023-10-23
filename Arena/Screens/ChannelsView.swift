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
                            if channelsData.channels?.channels.last?.id ?? -1 == channel.id {
                                if !channelsData.isLoading {
                                    channelsData.loadMore()
                                }
                            }
                        }
                    }
                    
                    if channelsData.isLoading {
                        LoadingSpinner()
                    }
                    
                    if channelsData.currentPage > channelsData.totalPages {
                        Text("Finished loading all channels")
                            .foregroundStyle(Color("surface-text-secondary"))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Pinned")
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink(destination: SearchView()) {
//                        Image(systemName: "magnifyingglass")
//                            .imageScale(.medium)
//                    }
//                }
            }
            .toolbarBackground(.thinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("background"))
        }
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
        .refreshable {
            do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
            channelsData.refresh()
        }
    }
}

#Preview {
    ChannelsView()
}
