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
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    } else {
        return ""
    }
}

func dateFromString(string: String) -> Date {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate] // Added format options
    let date = dateFormatter.date(from: string) ?? Date.now
    return date
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
