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
    static var description = IntentDescription("Select a channel from Are.na to display blocks from")

    // An example configurable parameter
    @Parameter(title: "Channel", default: "posterikas")
    var channelSlug: String
}
