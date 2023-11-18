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
        let userProfilePicURL = userData.user?.avatarImage.display ?? ""
        let userInitials = userData.user?.initials ?? ""
        let userFullName = userData.user?.fullName ?? ""
        let userCreatedAt = userData.user?.createdAt ?? ""
        let userChannels = channelsData.channels?.channels ?? []
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        ProfilePic(imageURL: userProfilePicURL, initials: userInitials, fontSize: 12, dimension: 52, cornerRadius: 64)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userFullName)")
                                .foregroundStyle(Color("text-primary"))
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Text("\(userCreatedAt)") // TODO: Figure out timestamp thing
                                .foregroundStyle(Color("surface-text-secondary"))
                                .font(.system(size: 14))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(userChannels, id: \.self.id) { channel in
                            ChannelCard(channel: channel)
                                .onAppear {
                                    if userChannels.count >= 2 {
                                        if userChannels[userChannels.count - 2].id == channel.id {
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
            .padding(.bottom, 4)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Profile")
                        .foregroundStyle(Color("text-primary"))
                        .font(.system(size: 20))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ChangeAppIconView()) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .foregroundStyle(Color("surface-text-secondary"))
                }
            }
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
