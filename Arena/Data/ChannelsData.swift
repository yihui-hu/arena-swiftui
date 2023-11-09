//
//  ArenaFetcher.swift
//  Arena
//
//  Created by Yihui Hu on 12/10/23.
//

import Foundation

@MainActor
final class ChannelsData: ObservableObject {
    @Published var channels: ArenaChannels?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init() {
        Task {
            do {
                try await fetchChannels(refresh: false)
            } catch {
                print(error)
            }
        }
    }
    
    final func loadMore() async throws {
        print("Fetching channels: page \(self.currentPage) of \(self.totalPages)")
        try await fetchChannels(refresh: false)
    }
    
    final func refresh() async throws {
        currentPage = 1
        totalPages = 1
        try await fetchChannels(refresh: true)
    }
    
    final func fetchChannels(refresh: Bool) async throws {
        // Check if we've finished fetching all pages
        guard currentPage <= totalPages else { return }
        guard !isLoading else { return }
        
        self.isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.are.na/v2/users/49570/channels?page=\(currentPage)&per=12") else {
            self.isLoading = false
            errorMessage = "Invalid URL"
            return
        }
        
        // Create a URLRequest and set the "Authorization" header with your bearer token
        var request = URLRequest(url: url)
        request.setValue("Bearer cfsNlJe3Ns9Vnj8SAKHLvDCaeh3uMm1sNwsIX6ESdeY", forHTTPHeaderField: "Authorization")
        
        // @TODO: Replace _ with response, and get HTTPResponseCode to throw any errors if necessary
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Attempt to decode the data
        let decoder = JSONDecoder()
        do {
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
            print("Decoding Error: \(decodingError)")
            throw decodingError
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
