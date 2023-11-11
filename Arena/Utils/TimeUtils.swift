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
        return ""
    }
}

func dayMonthYear(_ dateString: String) -> String {
    if dateString == "" {
        return ""
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    if let date = dateFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy"
        return "joined " + outputFormatter.string(from: date)
    } else {
        return ""
    }
}
