//
//  ChannelsData.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import Foundation
import Defaults

final class ChannelsData: ObservableObject {
    @Published var channels: ArenaChannels?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(userId: Int) {
        fetchChannels(userId: userId, refresh: false)
    }
    
    final func loadMore(userId: Int) {
        print("Fetching channels: page \(self.currentPage) of \(self.totalPages)")
        fetchChannels(userId: userId, refresh: false)
    }
    
    final func refresh(userId: Int) {
        currentPage = 1
        totalPages = 1
        fetchChannels(userId: userId, refresh: true)
    }
    
    final func fetchChannels(userId: Int, refresh: Bool) {
        // Check if we've finished fetching all pages
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }
        
        self.isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.are.na/v2/users/\(userId)/channels?page=\(currentPage)&per=10") else {
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
                    let newChannels = try decoder.decode(ArenaChannels.self, from: data)
                    DispatchQueue.main.async {
                        if self.channels != nil, !refresh {
                            self.channels?.channels.append(contentsOf: newChannels.channels)
                        } else {
                            self.channels = newChannels
                        }
                        self.totalPages = newChannels.totalPages
                        self.currentPage += 1
                        
                        // Fetch contents for each channel
//                        for channel in newChannels.channels {
//                            self.fetchChannelContents(for: channel)
//                        }
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
    
//    private func fetchChannelContents(for channel: ArenaChannelPreview) {
//        print(channel.slug)
//        
//        guard let url = URL(string: "https://api.are.na/v2/\(channel.slug)/contents?page=1&sort=position&direction=asc") else {
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
//        
//        
//        URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
//            if let error = error {
//                print("Error fetching channel contents: \(error.localizedDescription)")
//                return
//            }
//            
//            if let data = data {
//                let decoder = JSONDecoder()
//                do {
//                    let contents = try decoder.decode(ArenaChannelContents.self, from: data)
//                    DispatchQueue.main.async {
//                        if let index = self.channels?.channels.firstIndex(where: { $0.id == channel.id }) {
//                            self.channels?.channels[index].contents = contents.contents
//                        }
//                    }
//                } catch {
//                    print("Error decoding channel contents: \(error.localizedDescription)")
//                }
//            }
//        }
//        .resume()
//    }
}
