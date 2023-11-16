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
            VStack {
                if pinnedChannelsData.pinnedChannels.isEmpty {
                    VStack(alignment: .center) {
                        VStack(spacing: 16) {
                            Image(systemName: "questionmark.folder.fill")
                            Text("No pinned channels")
                        }
                    }
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
                                    .contentShape(ContentShapeKinds.contextMenuPreview, RoundedRectangle(cornerRadius: 32))
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
                    .padding(.bottom, 4)
                    .refreshable {
                        do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                        pinnedChannelsData.refresh()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color("background"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Pinned")
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
        .contentMargins(.leading, 0, for: .scrollIndicators)
        .contentMargins(16)
    }
    
    private func togglePin(_ channelId: Int) {
        if pinnedChannels.contains(channelId) {
            // If the channel is pinned, remove it from the view without refetching data
            if let index = pinnedChannelsData.channels?.firstIndex(where: { $0.id == channelId }) {
                var updatedChannels = pinnedChannelsData.channels ?? []
                updatedChannels.remove(at: index)
                pinnedChannelsData.channels = updatedChannels
            }
            
            // Remove the channel from the pinned channels list
            pinnedChannels.removeAll { $0 == channelId }
        } else {
            // If the channel is not pinned, fetch only that specific channel and append it to the view
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channelId)/?per=6)") else {
                return
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer cfsNlJe3Ns9Vnj8SAKHLvDCaeh3uMm1sNwsIX6ESdeY", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let channelContent = try decoder.decode(ArenaChannelPreview.self, from: data)
                        DispatchQueue.main.async {
                            var updatedChannels = pinnedChannelsData.channels ?? []
                            updatedChannels.append(channelContent)
                            pinnedChannelsData.channels = updatedChannels
                        }
                    } catch let decodingError {
                        print("Decoding Error: \(decodingError)")
                        return
                    }
                }
            }
            task.resume()

            // Append the channel to the pinned channels list
            pinnedChannels.append(channelId)
        }
    }

}

#Preview {
    PinnedChannelsView()
}


////
////  ChannelsView.swift
////  Arena
////
////  Created by Yihui Hu on 12/10/23.
////
//
//import SwiftUI
//import Defaults
//
//struct PinnedChannelsView: View {
//    @ObservedObject private var pinnedChannelsData = PinnedChannelsData()
//    @Default(.pinnedChannels) var pinnedChannels
//    
//    var PinnedChannelsHeader: some View {
//        Text("Pinned")
//            .font(.system(size: 20))
//            .fontDesign(.rounded)
//            .fontWeight(.semibold)
////            .padding(.top, 40)
////            .padding(.bottom, 8)
//            .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
//            .background(Color("background"))
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if pinnedChannelsData.pinnedChannels.isEmpty {
//                    VStack(alignment: .center) {
//                        VStack(spacing: 16) {
//                            Image(systemName: "questionmark.folder.fill")
//                            Text("No pinned channels")
//                        }
//                    }
//                } else {
//                    ScrollView {
//                        LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
//                            Section(header: PinnedChannelsHeader.ignoresSafeArea(edges: .top)) {
//                                ForEach(pinnedChannelsData.channels ?? [], id: \.id) { channel in
//                                    ChannelCard(channel: channel)
//                                        .onAppear {
//                                            if let channels = pinnedChannelsData.channels, channels.count >= 2 {
//                                                if channels[channels.count - 2].id == channel.id {
//                                                    pinnedChannelsData.loadMore()
//                                                }
//                                            }
//                                        }
//                                        .contentShape(ContentShapeKinds.contextMenuPreview, RoundedRectangle(cornerRadius: 32))
//                                        .contextMenu {
//                                            Button {
//                                                togglePin(channel.id)
//                                            } label: {
//                                                Label(pinnedChannels.contains(channel.id) ? "Unpin" : "Pin", systemImage: pinnedChannels.contains(channel.id) ? "pin.slash.fill" : "pin.fill")
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.bottom, 8)
//                    .refreshable {
//                        do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
//                        pinnedChannelsData.refresh()
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//            .background(Color("background"))
//            .toolbar(.hidden)
//            .overlay(alignment: .top) {
//                Color.clear
//                    .background(Color("background"))
//                    .ignoresSafeArea(edges: .top)
//                    .frame(height: 0)
//            }
//        }
//        .contentMargins(.leading, 0, for: .scrollIndicators)
//        .contentMargins(16)
//    }
//    
//    private func togglePin(_ channelId: Int) {
//        if pinnedChannels.contains(channelId) {
//            pinnedChannels.removeAll { $0 == channelId }
//        } else {
//            pinnedChannels.append(channelId)
//        }
//    }
//}
//
//#Preview {
//    PinnedChannelsView()
//}
