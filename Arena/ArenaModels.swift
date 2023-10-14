//
//  ArenaModels.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import Foundation
import SwiftUI

class ArenaChannels: Codable {
    let id: Int // id of user
    let length, totalPages, currentPage: Int
    var channels: [ArenaChannelPreview]
    
    enum CodingKeys: String, CodingKey {
        case id
        case length
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case channels
    }
    
    init(length: Int, totalPages: Int, currentPage: Int, id: Int, channels: [ArenaChannelPreview]) {
        self.length = length
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.id = id
        self.channels = channels
    }
}

// MARK: - ArenaChannelPreview
class ArenaChannelPreview: Codable {
    let id: Int
    let title, createdAt, updatedAt, addedToAt: String
    let published, channelOpen, collaboration: Bool
    let collaboratorCount: Int
    let slug: String
    let length: Int
    let status: String
    let userId: Int
    let metadata: Metadata?
    var contents: [Block]?
    let followerCount: Int
    let ownerId: Int
    let ownerSlug: String
    let nsfw: Bool
    let state: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case addedToAt = "added_to_at"
        case published
        case channelOpen = "open"
        case collaboration
        case collaboratorCount = "collaborator_count"
        case slug, length, status
        case userId = "user_id"
        case metadata, contents
        case followerCount = "follower_count"
        case ownerId = "owner_id"
        case ownerSlug = "owner_slug"
        case nsfw = "nsfw?"
        case state, user, id
    }
    
    init(title: String, createdAt: String, updatedAt: String, addedToAt: String, published: Bool, channelOpen: Bool, collaboration: Bool, collaboratorCount: Int, slug: String, length: Int, status: String, userId: Int, metadata: Metadata?, contents: [Block]?, followerCount: Int, ownerId: Int, ownerSlug: String, nsfw: Bool, state: String, user: User, id: Int) {
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.addedToAt = addedToAt
        self.published = published
        self.channelOpen = channelOpen
        self.collaboration = collaboration
        self.collaboratorCount = collaboratorCount
        self.slug = slug
        self.length = length
        self.status = status
        self.userId = userId
        self.metadata = metadata
        self.contents = contents
        self.followerCount = followerCount
        self.ownerId = ownerId
        self.ownerSlug = ownerSlug
        self.nsfw = nsfw
        self.state = state
        self.user = user
        self.id = id
    }
}

// MARK: - ArenaChannel
class ArenaChannel: Codable {
    let id: Int
    let title, createdAt, updatedAt, addedToAt: String
    let published, open, collaboration: Bool
    let collaboratorCount: Int
    let slug: String
    let length: Int
    let kind, status: String
    let userId: Int
    var contents: [Block]?
    let baseClass: String
    let page, per: Int
    let collaborators: [User]
    let followerCount: Int
    let metadata: Metadata?
    let className: String
    let canIndex, nsfw: Bool
    let owner, user: User

    enum CodingKeys: String, CodingKey {
        case id, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case addedToAt = "added_to_at"
        case published
        case open = "open"
        case collaboration
        case collaboratorCount = "collaborator_count"
        case slug, length, kind, status
        case userId = "user_id"
        case contents
        case baseClass = "base_class"
        case page, per, collaborators
        case followerCount = "follower_count"
        case metadata
        case className = "class_name"
        case canIndex = "can_index"
        case nsfw = "nsfw?"
        case owner, user
    }

    init(id: Int, title: String, createdAt: String, updatedAt: String, addedToAt: String, published: Bool, open: Bool, collaboration: Bool, collaboratorCount: Int, slug: String, length: Int, kind: String, status: String, userId: Int, contents: [Block]?, baseClass: String, page: Int, per: Int, collaborators: [User], followerCount: Int, metadata: Metadata?, className: String, canIndex: Bool, nsfw: Bool, owner: User, user: User) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.addedToAt = addedToAt
        self.published = published
        self.open = open
        self.collaboration = collaboration
        self.collaboratorCount = collaboratorCount
        self.slug = slug
        self.length = length
        self.kind = kind
        self.status = status
        self.userId = userId
        self.contents = contents
        self.baseClass = baseClass
        self.page = page
        self.per = per
        self.collaborators = collaborators
        self.followerCount = followerCount
        self.metadata = metadata
        self.className = className
        self.canIndex = canIndex
        self.nsfw = nsfw
        self.owner = owner
        self.user = user
    }
}

// MARK: - Block
class Block: Codable {
    let id: Int
    let title: String
    let updatedAt, createdAt: String // describes when block was updated and created
    let commentCount: Int?
    let generatedTitle: String?
    let visibility: String?
    let content: String?
    let description: String?
    let source: ArenaSource?
    let image: ArenaImage?
    let attachment: ArenaAttachment?
    let metadata: Metadata?
    let contentClass: String
    let user: User // original user who added block to Are.na
    let selected: Bool
    let connectionId: Int
    let connectedAt: String // describes when block was added to channel
    let connectedByUserId: Int // describes who added the block to channel
    let connectedByUsername, connectedByUserSlug: String
    let collaboratorCount: Int?
    let nsfw: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case commentCount = "comment_count"
        case generatedTitle = "generated_title"
        case visibility, content, description, source, image, metadata, id, attachment
        case contentClass = "class"
        case user, selected
        case connectionId = "connection_id"
        case connectedAt = "connected_at"
        case connectedByUserId = "connected_by_user_id"
        case connectedByUsername = "connected_by_username"
        case connectedByUserSlug = "connected_by_user_slug"
        case collaboratorCount = "collaborator_count"
        case nsfw = "nsfw?"
    }
    
    init(title: String, updatedAt: String, createdAt: String, commentCount: Int?, generatedTitle: String?, visibility: String?, content: String?, description: String?, source: ArenaSource?, image: ArenaImage?, attachment: ArenaAttachment?, metadata: Metadata?, id: Int, contentClass: String, user: User, selected: Bool, connectionId: Int, connectedAt: String, connectedByUserId: Int, connectedByUsername: String, connectedByUserSlug: String, collaboratorCount: Int?, nsfw: Bool?) {
        self.title = title
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.commentCount = commentCount
        self.generatedTitle = generatedTitle
        self.visibility = visibility
        self.content = content
        self.description = description
        self.source = source
        self.image = image
        self.attachment = attachment
        self.metadata = metadata
        self.id = id
        self.contentClass = contentClass
        self.user = user
        self.selected = selected
        self.connectionId = connectionId
        self.connectedAt = connectedAt
        self.connectedByUserId = connectedByUserId
        self.connectedByUsername = connectedByUsername
        self.connectedByUserSlug = connectedByUserSlug
        self.collaboratorCount = collaboratorCount
        self.nsfw = nsfw
    }
}

class ArenaAttachment: Codable {
    let filename, fileSizeDisplay, fileExtension, contentType, url: String
    let fileSize: Int
    
    enum CodingKeys: String, CodingKey {
        case filename = "file_name"
        case fileSize = "file_size"
        case fileSizeDisplay = "file_size_display"
        case fileExtension = "extension"
        case contentType = "content_type"
        case url
    }
    
    init(filename: String, fileSize: Int, fileSizeDisplay: String, fileExtension: String, contentType: String, url: String) {
        self.filename = filename
        self.fileSize = fileSize
        self.fileSizeDisplay = fileSizeDisplay
        self.fileExtension = fileExtension
        self.contentType = contentType
        self.url = url
    }
}

// MARK: - Image
class ArenaImage: Codable {
    let filename, contentType, updatedAt: String
    let thumb, square, display, large: Display
    let original: OriginalImage
    
    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
        case updatedAt = "updated_at"
        case thumb, square, display, large, original
    }
    
    init(filename: String, contentType: String, updatedAt: String, thumb: Display, square: Display, display: Display, large: Display, original: OriginalImage) {
        self.filename = filename
        self.contentType = contentType
        self.updatedAt = updatedAt
        self.thumb = thumb
        self.square = square
        self.display = display
        self.large = large
        self.original = original
    }
}

// MARK: - Display
struct Display: Codable {
    let url: String
}

// MARK: - Original
class OriginalImage: Codable {
    let url: String
    let fileSize: Int
    let fileSizeDisplay: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case fileSize = "file_size"
        case fileSizeDisplay = "file_size_display"
    }
    
    init(url: String, fileSize: Int, fileSizeDisplay: String) {
        self.url = url
        self.fileSize = fileSize
        self.fileSizeDisplay = fileSizeDisplay
    }
}

// MARK: - Metadata
class Metadata: Codable {
    let description: String?
    
    init(description: String?) {
        self.description = description
    }
}

// MARK: - Source
class ArenaSource: Codable {
    let url: String?
    let title: String?
    
    init(url: String?, title: String?) {
        self.url = url
        self.title = title
    }
}

// MARK: - User
class User: Codable {
    let createdAt, slug, username, firstName: String
    let lastName, fullName: String
    let avatarImage: AvatarImage
    let channelCount, followingCount, profileid, followerCount: Int
    let initials: String
    let badge: String?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case slug, username
        case firstName = "first_name"
        case lastName = "last_name"
        case fullName = "full_name"
        case avatarImage = "avatar_image"
        case channelCount = "channel_count"
        case followingCount = "following_count"
        case profileid = "profile_id"
        case followerCount = "follower_count"
        case initials
        case badge, id
    }
    
    init(createdAt: String, slug: String, username: String, firstName: String, lastName: String, fullName: String, avatarImage: AvatarImage, channelCount: Int, followingCount: Int, profileid: Int, followerCount: Int, initials: String, badge: String?, id: Int) {
        self.createdAt = createdAt
        self.slug = slug
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.avatarImage = avatarImage
        self.channelCount = channelCount
        self.followingCount = followingCount
        self.profileid = profileid
        self.followerCount = followerCount
        self.initials = initials
        self.badge = badge
        self.id = id
    }
}

// MARK: - AvatarImage
class AvatarImage: Codable {
    let thumb, display: String
    
    init(thumb: String, display: String) {
        self.thumb = thumb
        self.display = display
    }
}

// MARK: - ArenaError
enum ArenaError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

