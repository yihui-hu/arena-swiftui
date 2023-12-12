//
//  UserInfo.swift
//  Arena
//
//  Created by Yihui Hu on 21/11/23.
//

import SwiftUI
import Defaults
import CoreImage.CIFilterBuiltins

struct UserInfo: View {
    let userId: Int
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @StateObject var channelsData: ChannelsData
    @StateObject var userData: UserData
    @State private var selectedChannelSlug: String?
    @State private var isShareModalPresented: Bool = false
    
    @Default(.pinnedChannels) var pinnedChannels
    
    init(userId: Int) {
        self.userId = userId
        self._userData = StateObject(wrappedValue: UserData(userId: userId))
        self._channelsData = StateObject(wrappedValue: ChannelsData(userId: userId))
    }
    
    var body: some View {
        let userProfilePicURL = userData.user?.avatarImage.display ?? ""
        let userInitials = userData.user?.initials ?? ""
        let userSlug = userData.user?.slug ?? ""
        let userFullName = userData.user?.fullName ?? ""
        let userCreatedAt = userData.user?.createdAt ?? ""
        let userCreation = dateFromString(string: userCreatedAt)
        let userBadge = userData.user?.badge ?? ""
        let userChannels = channelsData.channels?.channels ?? []
        
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ProfilePic(imageURL: userProfilePicURL, initials: userInitials, fontSize: 12, dimension: 52, cornerRadius: 64)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userFullName)")
                                .foregroundStyle(Color("text-primary"))
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            
                            Text("Joined ")
                                .foregroundStyle(Color("surface-text-secondary"))
                                .font(.system(size: 14)) +
                            Text(userCreation, style: .date)
                                .foregroundStyle(Color("surface-text-secondary"))
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                        
                        if userBadge != "" {
                            Text("\(userBadge)")
                                .font(.system(size: 14))
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(userBadge == "supporter" ? "supporter-bg" : userBadge == "investor" ? "investor-bg" : "premium-bg"))
                                )
                                .foregroundStyle(Color(userBadge == "supporter" ? "supporter" : userBadge == "investor" ? "investor" : "premium"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack(spacing: 8) {
                        NavigationLink(destination: FollowView(userId: userId, type: "following")) {
                            Text("Following")
                                .font(.system(size: 15))
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                        }
                        
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("surface"))
                        .cornerRadius(16)
                        
                        NavigationLink(destination: FollowView(userId: userId, type: "followers")) {
                            Text("Followers")
                                .font(.system(size: 15))
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color("surface"))
                        .cornerRadius(16)
                    }
                    .foregroundStyle(Color("text-primary"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        isShareModalPresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding(.bottom, 4)
                            .imageScale(.small)
                            .fontWeight(.medium)
                            .frame(width: 32, height: 32, alignment: .center)
                            .background(Color("surface"))
                            .foregroundColor(Color("surface-text-secondary"))
                            .clipShape(Circle())
                    }
                }
                
                LazyVStack(spacing: 12) {
                    if !channelsData.isLoading, userChannels.isEmpty {
                        EmptyUserChannels()
                    } else {
                        ForEach(Array(zip(userChannels.indices, userChannels)), id: \.0) { _, channel in
                            ChannelCard(channel: channel)
                                .onAppear {
                                    if userChannels.count >= 1 {
                                        if userChannels[userChannels.count - 1].id == channel.id {
                                            channelsData.loadMore(userId: userId)
                                        }
                                    }
                                }
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
                                        togglePin(channel.id)
                                    } label: {
                                        Label(pinnedChannels.contains(channel.id) ? "Unpin" : "Pin", systemImage: pinnedChannels.contains(channel.id) ? "pin.slash.fill" : "pin.fill")
                                    }
                                }
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
        .refreshable {
            do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
            channelsData.refresh(userId: userId)
            userData.refresh(userId: userId)
        }
        .sheet(isPresented: $isShareModalPresented) {
            VStack(spacing: 20) {
                Image(uiImage: generateQRCode(from: "https://are.na/\(userSlug)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
                
                ShareLink(item: URL(string: "https://are.na/\(userSlug)")!) {
                    Text("Share Profile")
                        .font(.system(size: 14))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color("surface"))
                        )
                        .foregroundStyle(Color("surface-text-secondary"))
                }
            }
            .presentationDetents([.medium])
            .presentationCornerRadius(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
    }
    
    private func togglePin(_ channelId: Int) {
        if pinnedChannels.contains(channelId) {
            pinnedChannels.removeAll { $0 == channelId }
        } else {
            pinnedChannels.append(channelId)
        }
        Defaults[.pinnedChannelsChanged] = true
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.app") ?? UIImage()
    }
}

#Preview {
    UserInfo(userId: 49570)
}
