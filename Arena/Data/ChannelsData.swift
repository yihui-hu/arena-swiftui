//
//  ArenaFetcher.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import Foundation

final class ChannelsData: ObservableObject {
    @Published var channels: ArenaChannels?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init() {
        fetchChannels(refresh: false)
    }
    
    final func loadMore() {
        print("Fetching channels: page \(self.currentPage) of \(self.totalPages)")
        fetchChannels(refresh: false)
    }
    
    final func refresh() {
        currentPage = 1
        totalPages = 1
        fetchChannels(refresh: true)
    }
    
    final func fetchChannels(refresh: Bool) {
        // Check if we've finished fetching all pages
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.are.na/v2/users/49570/channels?page=\(currentPage)&per=10") else {
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
                    let newChannels = try decoder.decode(ArenaChannels.self, from: data)
                    DispatchQueue.main.async {
                        if self.channels != nil, !refresh {
                            self.channels?.channels.append(contentsOf: newChannels.channels)
                        } else {
                            self.channels = newChannels
                        }
                        self.totalPages = newChannels.totalPages
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
