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
                profileId: 4,
                followerCount: 8,
                initials: "FL",
                badge: "Badge",
                id: 5
            ),
            id: 6
        ),
    ]
)

//let sampleArenaBlock: Block = Block(
//    title: "Spirals",
//    updated_at: "2023-10-15T19:18:37.391Z",
//    comment_count: 0,
//    generated_title: "Spirals",
//    visibility: "private",
//    content: "",
//    description: "Generate beautiful AI spiral art with one click. Powered by Vercel and Replicate.",
//    source: ArenaSource(
//        url: "https://spirals.vercel.app/",
//        title: "Spirals"
//    ),
//    image: ArenaImage(filename: "6e25d674e48967ac7e0cd97828c75b1c.png", contentType: "image/png", updatedAt: "2023-10-15T19:18:37.237Z", thumb: Display(url: "https://images.are.na/eyJidWNrZXQiOiJhcmVuYV9pbWFnZXMiLCJrZXkiOiIyNDE3MzU5MC9vcmlnaW5hbF82ZTI1ZDY3NGU0ODk2N2FjN2UwY2Q5NzgyOGM3NWIxYy5wbmciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjQwMCwiaGVpZ2h0Ijo0MDAsImZpdCI6Imluc2lkZSIsIndpdGhvdXRFbmxhcmdlbWVudCI6dHJ1ZX0sIndlYnAiOnsicXVhbGl0eSI6OTB9LCJqcGVnIjp7InF1YWxpdHkiOjkwfSwicm90YXRlIjpudWxsfX0=?bc=0"), square: Display(url: "https://images.are.na/eyJidWNrZXQiOiJhcmVuYV9pbWFnZXMiLCJrZXkiOiIyNDE3MzU5MC9vcmlnaW5hbF82ZTI1ZDY3NGU0ODk2N2FjN2UwY2Q5NzgyOGM3NWIxYy5wbmciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjQ0MCwiaGVpZ2h0Ijo0NDAsImZpdCI6ImNvdmVyIiwid2l0aG91dEVubGFyZ2VtZW50Ijp0cnVlfSwid2VicCI6eyJxdWFsaXR5Ijo5MH0sImpwZWciOnsicXVhbGl0eSI6OTB9LCJyb3RhdGUiOm51bGx9fQ==?bc=0"), display: Display(url: "https://images.are.na/eyJidWNrZXQiOiJhcmVuYV9pbWFnZXMiLCJrZXkiOiIyNDE3MzU5MC9vcmlnaW5hbF82ZTI1ZDY3NGU0ODk2N2FjN2UwY2Q5NzgyOGM3NWIxYy5wbmciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjEyMDAsImhlaWdodCI6MTIwMCwiZml0IjoiaW5zaWRlIiwid2l0aG91dEVubGFyZ2VtZW50Ijp0cnVlfSwid2VicCI6eyJxdWFsaXR5Ijo5MH0sImpwZWciOnsicXVhbGl0eSI6OTB9LCJyb3RhdGUiOm51bGx9fQ==?bc=0"), large: Display(url: "https://images.are.na/eyJidWNrZXQiOiJhcmVuYV9pbWFnZXMiLCJrZXkiOiIyNDE3MzU5MC9vcmlnaW5hbF82ZTI1ZDY3NGU0ODk2N2FjN2UwY2Q5NzgyOGM3NWIxYy5wbmciLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjE4MDAsImhlaWdodCI6MTgwMCwiZml0IjoiaW5zaWRlIiwid2l0aG91dEVubGFyZ2VtZW50Ijp0cnVlfSwid2VicCI6eyJxdWFsaXR5Ijo5MH0sImpwZWciOnsicXVhbGl0eSI6OTB9LCJyb3RhdGUiOm51bGx9fQ==?bc=0"), original: OriginalImage(url: "https://d2w9rnfcy7mm78.cloudfront.net/24173590/original_6e25d674e48967ac7e0cd97828c75b1c.png?1697397517?bc=0", fileSize: 4144869, fileSizeDisplay: "3.95 MB")),
//    id: 24173590,
//    class: "Link",
//    user: User(createdAt: "2018-03-18T03:51:40.642Z", slug: "yihui-h", username: "Yihui H.", firstName: "Yihui", lastName: "H.", fullName: "Yihui H.", avatarImage: AvatarImage(thumb: "https://arena-avatars.s3.amazonaws.com/49570/small_810241674b087520dc397471c60c66dc.gif?1684382532", display: "https://arena-avatars.s3.amazonaws.com/49570/medium_810241674b087520dc397471c60c66dc.gif?1684382532"), channelCount: 83, followingCount: 60, profileId: 164628, followerCount: 45, initials: "YH", badge: "premium", id: 49570)
//)
