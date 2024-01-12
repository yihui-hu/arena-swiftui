//
//  BlockWidget.swift
//  BlockWidget
//
//  Created by Yihui Hu on 26/11/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = ConfigurationAppIntent
    
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(named: "placeholder")!, channelSlug: "", configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return .init(date: Date(), image: UIImage(named: "placeholder")!, channelSlug: "", configuration: ConfigurationAppIntent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let nextUpdate: Date = .now.addingTimeInterval(60 * 15)
        
        guard let image = try? await WidgetChannelData.fetchChannel(configuration.channelSlug) else {
            return Timeline(entries: [], policy: .after(nextUpdate))
        }
        
        let entry = SimpleEntry(date: Date(), image: image, channelSlug: configuration.channelSlug, configuration: ConfigurationAppIntent())
        
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
    let channelSlug: String
    let configuration: ConfigurationAppIntent
}

struct BlockWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .scaledToFit()
            .widgetURL(channelURL(for: entry.channelSlug))
    }
    
    private func channelURL(for channelSlug: String) -> URL? {
        return URL(string: "are-na://goToChannel?channelSlug=\(channelSlug)")
    }
}

struct BlockWidget: Widget {
    let kind: String = "BlockWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BlockWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Block Widget")
        .description("Displays a random block from Are.na Channel")
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
        ])
        .contentMarginsDisabled()
    }
}

// For preview purposes
extension ConfigurationAppIntent {
    fileprivate static var ui: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.channelSlug = "arena-widget"
        return intent
    }
}

#Preview(as: .systemSmall) {
    BlockWidget()
} timeline: {
    SimpleEntry(date: .now, image: UIImage(named: "placeholder")!, channelSlug: "", configuration: ConfigurationAppIntent())
}

struct WidgetChannelData {
    static func fetchChannel(_ channelSlug: String) async throws -> UIImage {
        var imageURL: String = "placeholder"
        let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let channelData = try JSONDecoder().decode(WidgetChannel.self, from: data)
        let totalPages = Int(ceil(Double(channelData.length) / Double(20)))
        let page = totalPages > 1 ? Int.random(in: 1..<totalPages) : 1
        
        let newUrl = URL(string: "https://api.are.na/v2/channels/\(channelSlug)?page=\(page)")!
        let (newData, _) = try await URLSession.shared.data(from: newUrl)
        let newChannelData = try JSONDecoder().decode(WidgetChannel.self, from: newData)
        let blocksCount = newChannelData.contents?.count ?? -1
        if blocksCount != -1 {
            var randomIndex = 0
            if blocksCount > 1 {
                randomIndex = Int.random(in: 0..<blocksCount)
            }
            
            imageURL = newChannelData.contents?[randomIndex].image?.display.url ?? "placeholder"
            let (imageData, _) = try await URLSession.shared.data(from: URL(string: imageURL)!)
            let image = UIImage(data: imageData)!
            
            return image
        } else {
            return UIImage(named: "error")!
        }
    }
}

final class WidgetChannel: Codable, Identifiable {
    let id: Int
    let contents: [WidgetBlock]?
    let length: Int
    
    enum CodingKeys: String, CodingKey {
        case id, contents, length
    }
    
    init(id: Int, contents: [WidgetBlock]?, length: Int) {
        self.id = id
        self.contents = contents
        self.length = length
    }
}

final class WidgetBlock: Codable, ObservableObject, Equatable {
    static func == (lhs: WidgetBlock, rhs: WidgetBlock) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let image: WidgetBlockImage?
    
    enum CodingKeys: String, CodingKey {
        case id, image
    }
    
    init(image: WidgetBlockImage?, id: Int) {
        self.image = image
        self.id = id
    }
}

final class WidgetBlockImage: Codable {
    let filename, contentType, updatedAt: String
    let thumb, square, display, large: WidgetBlockImageDisplay
    
    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
        case updatedAt = "updated_at"
        case thumb, square, display, large
    }
    
    init(filename: String, contentType: String, updatedAt: String, thumb: WidgetBlockImageDisplay, square: WidgetBlockImageDisplay, display: WidgetBlockImageDisplay, large: WidgetBlockImageDisplay) {
        self.filename = filename
        self.contentType = contentType
        self.updatedAt = updatedAt
        self.thumb = thumb
        self.square = square
        self.display = display
        self.large = large
    }
}

struct WidgetBlockImageDisplay: Codable {
    let url: String
}
