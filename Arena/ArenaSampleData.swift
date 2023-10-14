//
//  ArenaSampleData.swift
//  Arena
//
//  Created by Yihui Hu on 13/10/23.
//

import Foundation

let sampleArenaChannels: ArenaChannels = ArenaChannels(
    length: 1,
    totalPages: 1,
    currentPage: 1,
    id: 1,
    channels: [
        ArenaChannelPreview(
            title: "Channel 1",
            createdAt: "2023-10-13",
            updatedAt: "2023-10-13",
            addedToAt: "2023-10-13",
            published: true,
            channelOpen: true,
            collaboration: true,
            collaboratorCount: 3,
            slug: "channel-1",
            length: 5,
            status: "open",
            userId: 2,
            metadata: Metadata(description: "Description"),
            contents: [],
            followerCount: 10,
            ownerId: 3,
            ownerSlug: "owner-slug",
            nsfw: false,
            state: "State",
            user: User(
                createdAt: "2023-10-13",
                slug: "user-slug",
                username: "username",
                firstName: "First",
                lastName: "Last",
                fullName: "First Last",
                avatarImage: AvatarImage(thumb: "thumb-url", display: "display-url"),
                channelCount: 2,
                followingCount: 5,
                profileid: 4,
                followerCount: 8,
                initials: "FL",
                badge: "Badge",
                id: 5
            ),
            id: 6
        ),
    ]
)
