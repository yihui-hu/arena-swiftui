//
//  TimeUtils.swift
//  Arena
//
//  Created by Yihui Hu on 5/11/23.
//

import Foundation

func relativeTime(_ dateString: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    if let date = dateFormatter.date(from: dateString) {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    } else {
        return "unknown"
    }
}
