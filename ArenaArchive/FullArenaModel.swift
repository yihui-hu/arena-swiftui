////
////  ArenaModels.swift
////  Arena
////
////  Created by Yihui Hu on 12/10/23.
////
//
//import Foundation
//import SwiftUI
//
//class ArenaChannels: Codable {
//    let length, totalPages, currentPage, per: Int
//    let channelTitle: String?
//    let id: Int
//    let baseClass, welcomeClass: String
//    var channels: [Channel]
//    
//    enum CodingKeys: String, CodingKey {
//        case length
//        case totalPages = "total_pages"
//        case currentPage = "current_page"
//        case per
//        case channelTitle = "channel_title"
//        case id
//        case baseClass = "base_class"
//        case welcomeClass = "class"
//        case channels
//    }
//    
//    init(length: Int, totalPages: Int, currentPage: Int, per: Int, channelTitle: String?, id: Int, baseClass: String, welcomeClass: String, channels: [Channel]) {
//        self.length = length
//        self.totalPages = totalPages
//        self.currentPage = currentPage
//        self.per = per
//        self.channelTitle = channelTitle
//        self.id = id
//        self.baseClass = baseClass
//        self.welcomeClass = welcomeClass
//        self.channels = channels
//    }
//}
//
//// MARK: - Channel
//class Channel: Codable {
//    let title, createdAt, updatedAt, addedToAt: String
//    let published, channelOpen, collaboration: Bool
//    let collaboratorCount: Int
//    let slug: String
//    let length: Int
//    let kind, status: String
//    let userid: Int
//    let metadata: Metadata?
//    let contents: [Content]?
//    let shareLink: String?
//    let followerCount: Int
//    let canIndex: Bool
//    let ownerType: String
//    let ownerid: Int
//    let ownerSlug: String
//    let nsfw: Bool
//    let state: String
//    let user: User
//    let id: Int
//    let baseClass, channelClass: String
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case addedToAt = "added_to_at"
//        case published
//        case channelOpen = "open"
//        case collaboration
//        case collaboratorCount = "collaborator_count"
//        case slug, length, kind, status
//        case userid = "user_id"
//        case metadata, contents
//        case shareLink = "share_link"
//        case followerCount = "follower_count"
//        case canIndex = "can_index"
//        case ownerType = "owner_type"
//        case ownerid = "owner_id"
//        case ownerSlug = "owner_slug"
//        case nsfw = "nsfw?"
//        case state, user, id
//        case baseClass = "base_class"
//        case channelClass = "class"
//    }
//    
//    init(title: String, createdAt: String, updatedAt: String, addedToAt: String, published: Bool, channelOpen: Bool, collaboration: Bool, collaboratorCount: Int, slug: String, length: Int, kind: String, status: String, userid: Int, metadata: Metadata?, contents: [Content]?, shareLink: String?, followerCount: Int, canIndex: Bool, ownerType: String, ownerid: Int, ownerSlug: String, nsfw: Bool, state: String, user: User, id: Int, baseClass: String, channelClass: String) {
//        self.title = title
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//        self.addedToAt = addedToAt
//        self.published = published
//        self.channelOpen = channelOpen
//        self.collaboration = collaboration
//        self.collaboratorCount = collaboratorCount
//        self.slug = slug
//        self.length = length
//        self.kind = kind
//        self.status = status
//        self.userid = userid
//        self.metadata = metadata
//        self.contents = contents
//        self.shareLink = shareLink
//        self.followerCount = followerCount
//        self.canIndex = canIndex
//        self.ownerType = ownerType
//        self.ownerid = ownerid
//        self.ownerSlug = ownerSlug
//        self.nsfw = nsfw
//        self.state = state
//        self.user = user
//        self.id = id
//        self.baseClass = baseClass
//        self.channelClass = channelClass
//    }
//}
//
//// MARK: - Content
//class Content: Codable {
//    let title: String
//    let updatedAt, createdAt, state: String
//    let commentCount: Int?
//    let generatedTitle: String?
//    let contenthtml, descriptionhtml, visibility: String?
//    let content: String?
//    let description: String?
//    let source: Source?
//    let image: ArenaImage?
//    let metadata: Metadata?
//    let id: Int
//    let baseClass, contentClass: String
//    let user: User
//    let position: Int
//    let selected: Bool
//    let connectionid: Int
//    let connectedAt: String
//    let connectedByUserid: Int
//    let connectedByUsername, connectedByUserSlug: String
//    let addedToAt: String?
//    let published, contentOpen, collaboration: Bool?
//    let collaboratorCount: Int?
//    let slug: String?
//    let length: Int?
//    let kind, status: String?
//    let userid: Int?
//    let followerCount: Int?
//    let canIndex: Bool?
//    let ownerType: String?
//    let ownerid: Int?
//    let ownerSlug: String?
//    let nsfw: Bool?
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case updatedAt = "updated_at"
//        case createdAt = "created_at"
//        case state
//        case commentCount = "comment_count"
//        case generatedTitle = "generated_title"
//        case contenthtml = "content_html"
//        case descriptionhtml = "description_html"
//        case visibility, content, description, source, image, metadata, id
//        case baseClass = "base_class"
//        case contentClass = "class"
//        case user, position, selected
//        case connectionid = "connection_id"
//        case connectedAt = "connected_at"
//        case connectedByUserid = "connected_by_user_id"
//        case connectedByUsername = "connected_by_username"
//        case connectedByUserSlug = "connected_by_user_slug"
//        case addedToAt = "added_to_at"
//        case published
//        case contentOpen = "open"
//        case collaboration
//        case collaboratorCount = "collaborator_count"
//        case slug, length, kind, status
//        case userid = "user_id"
//        case followerCount = "follower_count"
//        case canIndex = "can_index"
//        case ownerType = "owner_type"
//        case ownerid = "owner_id"
//        case ownerSlug = "owner_slug"
//        case nsfw = "nsfw?"
//    }
//    
//    init(title: String, updatedAt: String, createdAt: String, state: String, commentCount: Int?, generatedTitle: String?, contenthtml: String?, descriptionhtml: String?, visibility: String?, content: String?, description: String?, source: Source?, image: ArenaImage?, metadata: Metadata?, id: Int, baseClass: String, contentClass: String, user: User, position: Int, selected: Bool, connectionid: Int, connectedAt: String, connectedByUserid: Int, connectedByUsername: String, connectedByUserSlug: String, addedToAt: String?, published: Bool?, contentOpen: Bool?, collaboration: Bool?, collaboratorCount: Int?, slug: String?, length: Int?, kind: String?, status: String?, userid: Int?, followerCount: Int?, canIndex: Bool?, ownerType: String?, ownerid: Int?, ownerSlug: String?, nsfw: Bool?) {
//        self.title = title
//        self.updatedAt = updatedAt
//        self.createdAt = createdAt
//        self.state = state
//        self.commentCount = commentCount
//        self.generatedTitle = generatedTitle
//        self.contenthtml = contenthtml
//        self.descriptionhtml = descriptionhtml
//        self.visibility = visibility
//        self.content = content
//        self.description = description
//        self.source = source
//        self.image = image
//        self.metadata = metadata
//        self.id = id
//        self.baseClass = baseClass
//        self.contentClass = contentClass
//        self.user = user
//        self.position = position
//        self.selected = selected
//        self.connectionid = connectionid
//        self.connectedAt = connectedAt
//        self.connectedByUserid = connectedByUserid
//        self.connectedByUsername = connectedByUsername
//        self.connectedByUserSlug = connectedByUserSlug
//        self.addedToAt = addedToAt
//        self.published = published
//        self.contentOpen = contentOpen
//        self.collaboration = collaboration
//        self.collaboratorCount = collaboratorCount
//        self.slug = slug
//        self.length = length
//        self.kind = kind
//        self.status = status
//        self.userid = userid
//        self.followerCount = followerCount
//        self.canIndex = canIndex
//        self.ownerType = ownerType
//        self.ownerid = ownerid
//        self.ownerSlug = ownerSlug
//        self.nsfw = nsfw
//    }
//}
//
//// MARK: - Image
//class ArenaImage: Codable {
//    let filename, contentType, updatedAt: String
//    let thumb, square, display, large: Display
//    let original: Original
//    
//    enum CodingKeys: String, CodingKey {
//        case filename
//        case contentType = "content_type"
//        case updatedAt = "updated_at"
//        case thumb, square, display, large, original
//    }
//    
//    init(filename: String, contentType: String, updatedAt: String, thumb: Display, square: Display, display: Display, large: Display, original: Original) {
//        self.filename = filename
//        self.contentType = contentType
//        self.updatedAt = updatedAt
//        self.thumb = thumb
//        self.square = square
//        self.display = display
//        self.large = large
//        self.original = original
//    }
//}
//
//// MARK: - Display
//class Display: Codable {
//    let url: String
//    
//    init(url: String) {
//        self.url = url
//    }
//}
//
//// MARK: - Original
//class Original: Codable {
//    let url: String
//    let fileSize: Int
//    let fileSizeDisplay: String
//    
//    enum CodingKeys: String, CodingKey {
//        case url
//        case fileSize = "file_size"
//        case fileSizeDisplay = "file_size_display"
//    }
//    
//    init(url: String, fileSize: Int, fileSizeDisplay: String) {
//        self.url = url
//        self.fileSize = fileSize
//        self.fileSizeDisplay = fileSizeDisplay
//    }
//}
//
//// MARK: - Metadata
//class Metadata: Codable {
//    let description: String?
//    
//    init(description: String?) {
//        self.description = description
//    }
//}
//
//// MARK: - Source
//class Source: Codable {
//    let url: String?
//    let title: String?
//    let provider: Provider?
//    
//    init(url: String?, title: String?, provider: Provider) {
//        self.url = url
//        self.title = title
//        self.provider = provider
//    }
//}
//
//// MARK: - Provider
//class Provider: Codable {
//    let name: String?
//    let url: String?
//    
//    init(name: String?, url: String) {
//        self.name = name
//        self.url = url
//    }
//}
//
//// MARK: - User
//class User: Codable {
//    let createdAt, slug, username, firstName: String
//    let lastName, fullName: String
//    let avatar: String
//    let avatarImage: AvatarImage
//    let channelCount, followingCount, profileid, followerCount: Int
//    let initials: String
//    let canIndex: Bool
//    let metadata: Metadata
//    let isPremium, isLifetimePremium, isSupporter, isExceedingConnectionsLimit: Bool
//    let isConfirmed, isPendingReconfirmation, isPendingConfirmation: Bool
//    let badge: String?
//    let id: Int
//    let baseClass, userClass: String
//    
//    enum CodingKeys: String, CodingKey {
//        case createdAt = "created_at"
//        case slug, username
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case fullName = "full_name"
//        case avatar
//        case avatarImage = "avatar_image"
//        case channelCount = "channel_count"
//        case followingCount = "following_count"
//        case profileid = "profile_id"
//        case followerCount = "follower_count"
//        case initials
//        case canIndex = "can_index"
//        case metadata
//        case isPremium = "is_premium"
//        case isLifetimePremium = "is_lifetime_premium"
//        case isSupporter = "is_supporter"
//        case isExceedingConnectionsLimit = "is_exceeding_connections_limit"
//        case isConfirmed = "is_confirmed"
//        case isPendingReconfirmation = "is_pending_reconfirmation"
//        case isPendingConfirmation = "is_pending_confirmation"
//        case badge, id
//        case baseClass = "base_class"
//        case userClass = "class"
//    }
//    
//    init(createdAt: String, slug: String, username: String, firstName: String, lastName: String, fullName: String, avatar: String, avatarImage: AvatarImage, channelCount: Int, followingCount: Int, profileid: Int, followerCount: Int, initials: String, canIndex: Bool, metadata: Metadata, isPremium: Bool, isLifetimePremium: Bool, isSupporter: Bool, isExceedingConnectionsLimit: Bool, isConfirmed: Bool, isPendingReconfirmation: Bool, isPendingConfirmation: Bool, badge: String?, id: Int, baseClass: String, userClass: String) {
//        self.createdAt = createdAt
//        self.slug = slug
//        self.username = username
//        self.firstName = firstName
//        self.lastName = lastName
//        self.fullName = fullName
//        self.avatar = avatar
//        self.avatarImage = avatarImage
//        self.channelCount = channelCount
//        self.followingCount = followingCount
//        self.profileid = profileid
//        self.followerCount = followerCount
//        self.initials = initials
//        self.canIndex = canIndex
//        self.metadata = metadata
//        self.isPremium = isPremium
//        self.isLifetimePremium = isLifetimePremium
//        self.isSupporter = isSupporter
//        self.isExceedingConnectionsLimit = isExceedingConnectionsLimit
//        self.isConfirmed = isConfirmed
//        self.isPendingReconfirmation = isPendingReconfirmation
//        self.isPendingConfirmation = isPendingConfirmation
//        self.badge = badge
//        self.id = id
//        self.baseClass = baseClass
//        self.userClass = userClass
//    }
//}
//
//// MARK: - AvatarImage
//class AvatarImage: Codable {
//    let thumb, display: String
//    
//    init(thumb: String, display: String) {
//        self.thumb = thumb
//        self.display = display
//    }
//}
//
//// MARK: - Encode/decode helpers
//class JSONNull: Codable, Hashable {
//    
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//    
//    public var hashValue: Int {
//        return 0
//    }
//    
//    public init() {}
//    
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
//let sampleData: ArenaChannels = ArenaChannels(
//    length: 10,
//    totalPages: 2,
//    currentPage: 1,
//    per: 5,
//    channelTitle: nil,
//    id: 1,
//    baseClass: "Base",
//    welcomeClass: "Welcome",
//    channels: [
//        Channel(
//            title: "Channel 1",
//            createdAt: "2023-10-13",
//            updatedAt: "2023-10-13",
//            addedToAt: "2023-10-13",
//            published: true,
//            channelOpen: true,
//            collaboration: true,
//            collaboratorCount: 3,
//            slug: "channel-1",
//            length: 5,
//            kind: "Kind",
//            status: "Status",
//            userid: 2,
//            metadata: Metadata(description: "Description"),
//            contents: nil,
//            shareLink: "https://example.com",
//            followerCount: 10,
//            canIndex: true,
//            ownerType: "Owner Type",
//            ownerid: 3,
//            ownerSlug: "owner-slug",
//            nsfw: false,
//            state: "State",
//            user: User(
//                createdAt: "2023-10-13",
//                slug: "user-slug",
//                username: "username",
//                firstName: "First",
//                lastName: "Last",
//                fullName: "First Last",
//                avatar: "avatar-url",
//                avatarImage: AvatarImage(thumb: "thumb-url", display: "display-url"),
//                channelCount: 2,
//                followingCount: 5,
//                profileid: 4,
//                followerCount: 8,
//                initials: "FL",
//                canIndex: true,
//                metadata: Metadata(description: "User Description"),
//                isPremium: true,
//                isLifetimePremium: false,
//                isSupporter: true,
//                isExceedingConnectionsLimit: false,
//                isConfirmed: true,
//                isPendingReconfirmation: false,
//                isPendingConfirmation: false,
//                badge: "Badge",
//                id: 5,
//                baseClass: "User Base",
//                userClass: "User Class"
//            ),
//            id: 6,
//            baseClass: "Channel Base",
//            channelClass: "Channel Class"
//        ),
//    ]
//)
