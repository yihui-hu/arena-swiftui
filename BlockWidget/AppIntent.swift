//
//  AppIntent.swift
//  BlockWidget
//
//  Created by Yihui Hu on 26/11/23.
//

import WidgetKit
import AppIntents

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
struct ConfigurationAppIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Are.na Channel"
    static var description = IntentDescription("Type a public channel from Are.na to display blocks from")
    // An example configurable parameter
    @Parameter(title: "Channel Slug", default: "arena-widget")
    var channelSlug: String
}
