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
    
    init(pinnedChannels: [Int]) {
        fetchChannels(pinnedChannels: pinnedChannels, refresh: false)
    }
    
    final func loadMore(pinnedChannels: [Int]) {
        fetchChannels(pinnedChannels: pinnedChannels, refresh: false)
    }
    
    final func refresh(pinnedChannels: [Int]) {
        fetchChannels(pinnedChannels: pinnedChannels, refresh: true)
    }
    
    final func fetchChannels(pinnedChannels: [Int], refresh: Bool) {
        guard !isLoading else {
            return
        }
        
        if refresh {
            self.channels = []
        }

        self.isLoading = true
        errorMessage = nil
        
        let dispatchGroup = DispatchGroup()

        var updatedChannels = self.channels ?? []

        for channelId in pinnedChannels {
            dispatchGroup.enter()
            
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channelId)/thumb") else {
                dispatchGroup.leave()
                continue
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                defer {
                    dispatchGroup.leave()
                }

                guard error == nil else {
                    errorMessage = "Error retrieving data: \(error!.localizedDescription)"
                    return
                }

                guard let data = data else {
                    return
                }

                let decoder = JSONDecoder()
                do {
                    let channelContent = try decoder.decode(ArenaChannelPreview.self, from: data)
                    updatedChannels.append(channelContent)
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    errorMessage = "Error decoding data: \(decodingError.localizedDescription)"
                }
            }

            task.resume()
        }

        dispatchGroup.notify(queue: .main) {
            // sort results, since dispatchGroup runs tasks in parallel with no respect for order
            updatedChannels.sort { object1, object2 in
                guard let index1 = Defaults[.pinnedChannels].firstIndex(of: object1.id),
                      let index2 = Defaults[.pinnedChannels].firstIndex(of: object2.id) else {
                    return false
                }
                return index1 < index2
            }
            self.channels = updatedChannels
            self.isLoading = false
        }
    }

}
