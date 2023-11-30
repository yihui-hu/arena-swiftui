//
//  PinnedChannelsData.swift
//  Arena
//
//  Created by Yihui Hu on 10/11/23.
//

import Foundation
import Defaults

final class PinnedChannelsData: ObservableObject {
    @Published var channels: [ArenaChannelPreview]?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Default(.pinnedChannels) var pinnedChannels: [Int]
    
    private var lastProcessedIndex: Int = 0
    private let batchSize: Int = 5
    
    init() {
        fetchChannels(refresh: false)
    }
    
    final func loadMore() {
        print("Fetching more pinned channels")
        fetchChannels(refresh: false)
    }
    
    final func refresh() {
        fetchChannels(refresh: true)
    }
    
    final func fetchChannels(refresh: Bool) {
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        let startIndex = lastProcessedIndex
        let endIndex = min(lastProcessedIndex + batchSize, pinnedChannels.count)

        guard startIndex < endIndex else {
            // All channels have been processed
            self.isLoading = false
            return
        }

        let channelIdsToFetch = Array(pinnedChannels[startIndex..<endIndex])

        let dispatchGroup = DispatchGroup()

        for channelId in channelIdsToFetch {
            dispatchGroup.enter()
            
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channelId)/?per=6)") else {
                dispatchGroup.leave()
                continue
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                defer {
                    dispatchGroup.leave()
                }

                if error != nil {
                    return
                }

                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let channelContent = try decoder.decode(ArenaChannelPreview.self, from: data)
                        DispatchQueue.main.async {
                            var updatedChannels = self.channels ?? []
                            if !refresh {
                                updatedChannels.append(channelContent)
                            } else {
                                updatedChannels = [channelContent]
                            }
                            self.channels = updatedChannels
                        }
                    } catch let decodingError {
                        print("Decoding Error: \(decodingError)")
                        return
                    }
                }
            }
            task.resume()
        }

        dispatchGroup.notify(queue: .main) {
            self.lastProcessedIndex += self.batchSize
            self.isLoading = false
        }
    }
}
