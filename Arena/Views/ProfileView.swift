//
//  ProfileView.swift
//  Arena
//
//  Created by Yihui Hu on 22/10/23.
//

import SwiftUI
import Defaults

struct ProfileView: View {
    let userId: Int
    @StateObject var channelsData: ChannelsData
    @StateObject var userData: UserData
    @State private var selectedChannelSlug: String?
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init(userId: Int) {
        self.userId = userId
        self._userData = StateObject(wrappedValue: UserData(userId: userId))
        self._channelsData = StateObject(wrappedValue: ChannelsData(userId: userId))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        ProfilePic(imageURL: userData.user?.avatarImage.display ?? "", initials: userData.user?.initials ?? "", fontSize: 12, dimension: 52, cornerRadius: 64) // TODO: Profile pics are zoomed in, need to fix
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userData.user?.fullName ?? "")")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Text("\(userData.user?.createdAt ?? "")") // TODO: Figure out timestamp thing
                                .font(.system(size: 14))
                                .foregroundStyle(Color("surface-text-secondary"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(channelsData.channels?.channels ?? [], id: \.self.id) { channel in
                            ChannelCard(channel: channel)
                                .onAppear {
                                    if let channels = channelsData.channels?.channels, channels.count >= 2 {
                                        if channels[channels.count - 2].id == channel.id {
                                            channelsData.loadMore(userId: userId)
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
            }
            .padding(.bottom, 8)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Text("Profile")
//                        .font(.system(size: 20))
//                        .fontDesign(.rounded)
//                        .fontWeight(.semibold)
//                }
//            }
            .overlay(alignment: .top) {
                Color.clear
                    .background(Color("background"))
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 0)
            }
            .toolbarBackground(Color("background"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("background"))
            .refreshable {
                do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
                channelsData.refresh(userId: userId)
                userData.refresh(userId: userId)
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
    ProfileView(userId: 49570)
}
