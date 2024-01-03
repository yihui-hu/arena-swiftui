//
//  AddToRabbitHole.swift
//  Arena
//
//  Created by Yihui Hu on 2/1/24.
//

import Foundation
import Defaults

func AddBlockToRabbitHole(block: Block) {
    let id = UUID()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm, d MMM y"
    let timestamp = formatter.string(from: Date.now)
    
    var mainText = ""
    var subText = ""
    var subtype = ""
    let imageUrl = block.image?.display.url ?? ""
    
    if block.contentClass == "Link" {
        subtype = "link"
        mainText = block.title != "" ? block.title : block.source?.url ?? ""
        // Attachment
    } else if block.attachment != nil {
        subtype = "attachment"
        mainText = block.title != "" ? block.title : block.attachment?.filename ?? ""
        subText = block.attachment?.fileExtension ?? ""
        // Image block
    } else if block.image != nil {
        subtype = "image"
        mainText = block.title != "" ? block.title : block.image?.filename ?? ""
        // Text block
    } else if block.content != nil {
        subtype = "text"
        mainText = block.title != "" ? block.title : block.content ?? ""
        subText = block.content ?? ""
        // Default to title
    } else if block.title != "" {
        subtype = "text"
        mainText = block.title != "" ? block.title : block.content ?? ""
        subText = block.content ?? ""
        // NIL case
    } else {
        subtype = "text"
        mainText = "No preview available"
        subText = "-"
    }
    
    Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "block", subtype: subtype, itemId: String(block.id), timestamp: timestamp, mainText: mainText, subText: subText, imageUrl: imageUrl), at: 0)
}

func AddUserToRabbitHole(user: User) {
    let id = UUID()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm, d MMM y"
    let timestamp = formatter.string(from: Date.now)
    
    Defaults[.rabbitHole].insert(RabbitHoleItem(id: id.uuidString, type: "user", subtype: "", itemId: String(user.id), timestamp: timestamp, mainText: user.fullName, subText: user.initials, imageUrl: user.avatarImage.thumb), at: 0)
}
