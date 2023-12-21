//
//  ChannelConnectionsData.swift
//  Arena
//
//  Created by Yihui Hu on 20/12/23.
//

import Foundation
import Defaults

final class ChannelConnectionsData: ObservableObject {
    @Published var channelConnections: [ArenaSearchedChannel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(channelSlug: String) {
        fetchChannelConnections(channelSlug)
    }
    
    final func loadMore(channelSlug: String) {
        fetchChannelConnections(channelSlug)
    }
    
    final func refresh(channelSlug: String) {
        channelConnections = []
        currentPage = 1
        totalPages = 1
        fetchChannelConnections(channelSlug)
    }
    
    final func fetchChannelConnections(_ channelSlug: String) {
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)/connections?page=\(currentPage)") else {
            self.isLoading = false
            errorMessage = "Invalid URL"
            return
        }
    
        // Create a URLRequest and set the "Authorization" header with your bearer token
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if error != nil {
                errorMessage = "Error retrieving data."
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // Attempt to decode the data
                    let channelConnectionsData = try decoder.decode(ChannelConnections.self, from: data)
                    DispatchQueue.main.async {
                        if self.channelConnections.isEmpty {
                            self.channelConnections = channelConnectionsData.channels
                        } else {
                            self.channelConnections.append(contentsOf: channelConnectionsData.channels)
                        }
                        self.totalPages = channelConnectionsData.totalPages
                        self.currentPage += 1
                    }
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    errorMessage = "Error decoding data: \(decodingError.localizedDescription)"
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        task.resume()
    }

}
