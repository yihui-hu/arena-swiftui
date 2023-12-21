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
    let itemId: String
    let timestamp: String
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
            "itemId": value.itemId,
            "timestamp": value.timestamp
        ]
    }

    public func deserialize(_ object: Serializable?) -> Value? {
        guard
            let object,
            let id = object["id"],
            let type = object["type"],
            let itemId = object["itemId"],
            let timestamp = object["timestamp"]
        else {
            return nil
        }

        return RabbitHoleItem(
            id: id,
            type: type,
            itemId: itemId,
            timestamp: timestamp
        )
    }
}

extension RabbitHoleItem: Defaults.Serializable {
    static let bridge = RabbitHoleItemBridge()
}
