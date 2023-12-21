//
//  FollowView.swift
//  Arena
//
//  Created by Yihui Hu on 3/12/23.
//

import SwiftUI
import Defaults

struct FollowView: View {
    let userId: Int
    let type: String
    @StateObject private var followData: UserFollowData
    @Environment(\.dismiss) private var dismiss
    
    init(userId: Int, type: String) {
        self.userId = userId
        self.type = type
        self._followData = StateObject(wrappedValue: UserFollowData(userId: userId, type: type))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                Text(followData.isLoading ? "Loading..." : "\(followData.count) \(type)")
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color("text-secondary"))
                    .padding(.bottom, 4)
                
                ForEach(followData.users ?? [], id: \.id) { user in
                    NavigationLink(destination: UserView(userId: user.id)) {
                        UserPreview(user: user)
                    }
                    .onAppear {
                        if followData.users?.last?.id ?? -1 == user.id {
                            if !followData.isLoading {
                                followData.loadMore(userId: userId, type: type)
                            }
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        let id = UUID()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm E, d MMM y"
                        let timestamp = formatter.string(from: Date.now)
                        Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "user", itemId: String(user.id), timestamp: timestamp), at: 0)
                    })
                }
                
                if (followData.isLoading) {
                    CircleLoadingSpinner()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                }
                
                if let followContent = followData.users, followContent.isEmpty {
                    EmptyFollowView(text: type)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if followData.currentPage > followData.totalPages {
                    EndOfFollowView(text: type)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .refreshable {
            do { try await Task.sleep(nanoseconds: 500_000_000) } catch {}
            followData.refresh(userId: userId, type: type)
        }
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

#Preview {
    FollowView(userId: 49570, type: "followers")
}
