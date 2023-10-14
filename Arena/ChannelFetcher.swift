//
//  ChannelFetcher.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import Foundation

class ChannelFetcher: ObservableObject {
    @Published var channel: ArenaChannel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(channelSlug: String) {
        fetchChannel(channelSlug)
    }
    
    // Lol unnecessary but useful for semantic organization
    func loadMore(channelSlug: String) {
        fetchChannel(channelSlug)
    }
    
    func refresh(channelSlug: String) {
        channel = nil
        currentPage = 1
        totalPages = 1
        fetchChannel(channelSlug)
    }
    
    func fetchChannel(_ channelSlug: String) {
        // Check if we've finished fetching all pages
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)?page=\(currentPage)") else {
            self.isLoading = false
            errorMessage = "Invalid URL"
            return
        }

        // Create a URLRequest and set the "Authorization" header with your bearer token
        var request = URLRequest(url: url)
        request.setValue("Bearer cfsNlJe3Ns9Vnj8SAKHLvDCaeh3uMm1sNwsIX6ESdeY", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
            if error != nil {
                errorMessage = "Error retrieving data."
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // Attempt to decode the data
                    let newChannelContent = try decoder.decode(ArenaChannel.self, from: data)
                    DispatchQueue.main.async {
                        if self.channel != nil {
                            if self.channel?.contents == nil {
                                self.channel?.contents = []
                            }
                            self.channel?.contents!.append(contentsOf: newChannelContent.contents ?? [])
                        } else {
                            self.channel = newChannelContent
                        }
                        self.totalPages = newChannelContent.length / 20
                        self.currentPage += 1
                    }
                } catch let decodingError {
                    // Print the decoding error for debugging
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
