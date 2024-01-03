//
//  CustomDefaults.swift
//  Arena
//
//  Created by Yihui Hu on 20/12/23.
//

import Foundation
import Defaults

struct RabbitHoleItem {
    let id: String
    let type: String
    let subtype: String
    let itemId: String
    let timestamp: String
    let mainText: String
    let subText: String
    let imageUrl: String
}

struct RabbitHoleItemBridge: Defaults.Bridge {
    typealias Value = RabbitHoleItem
    typealias Serializable = [String: String]

    public func serialize(_ value: Value?) -> Serializable? {
        guard let value else {
            return nil
        }

        return [
            "id": value.id,
            "type": value.type,
            "subtype": value.subtype,
            "itemId": value.itemId,
            "timestamp": value.timestamp,
            "mainText": value.mainText,
            "subText": value.subText,
            "imageUrl": value.imageUrl
        ]
    }

    public func deserialize(_ object: Serializable?) -> Value? {
        guard
            let object,
            let id = object["id"],
            let type = object["type"],
            let subtype = object["subtype"],
            let itemId = object["itemId"],
            let timestamp = object["timestamp"],
            let mainText = object["mainText"],
            let subText = object["subText"],
            let imageUrl = object["imageUrl"]
        else {
            return nil
        }

        return RabbitHoleItem(
            id: id,
            type: type,
            subtype: subtype,
            itemId: itemId,
            timestamp: timestamp,
            mainText: mainText,
            subText: subText,
            imageUrl: imageUrl
        )
    }
}

extension RabbitHoleItem: Defaults.Serializable {
    static let bridge = RabbitHoleItemBridge()
}
