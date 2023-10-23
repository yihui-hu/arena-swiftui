//
//  ChannelFetcher.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import Foundation

final class ChannelData: ObservableObject {
    @Published var channel: ArenaChannel?
    @Published var contents: [Block]?
    @Published var isLoading: Bool = false
    @Published var isContentsLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selection: SortOption = SortOption.newest
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    // MARK: - ChannelData Initializer
    init(channelSlug: String, selection: SortOption) {
        self.selection = selection
        fetchChannel(channelSlug)
        fetchChannelContents(channelSlug, refresh: false)
    }
    
    // MARK: - Fetch more content
    final func loadMore(channelSlug: String) {
        print("Fetching channel content: page \(self.currentPage) of \(self.totalPages)")
        fetchChannelContents(channelSlug, refresh: false)
    }
    
    // MARK: - Refresh Channel Metadata & Contents
    final func refresh(channelSlug: String, selection: SortOption) {
        currentPage = 1
        totalPages = 1
        self.selection = selection
        fetchChannel(channelSlug)
        fetchChannelContents(channelSlug, refresh: true)
    }
    
    // MARK: - Fetch Channel Metadata
    final func fetchChannel(_ channelSlug: String) {
        guard !isLoading else {
            return
        }
        
        self.isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)") else {
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
                    let channelData = try decoder.decode(ArenaChannel.self, from: data)
                    DispatchQueue.main.async {
                        self.channel = channelData
                        self.totalPages = Int(ceil(Double(channelData.length) / Double(20)))
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
    
    // MARK: - Fetch Channel Contents
    final func fetchChannelContents(_ channelSlug: String, refresh: Bool) {
        guard currentPage <= totalPages else {
            print("Done fetching, so returning now...")
            return
        }
        
        guard !isContentsLoading else {
            return
        }
        
        self.isContentsLoading = true
        errorMessage = nil
        
        let sortOption: String
        let sortDirection: String
        switch selection {
        case .position:
            sortOption = "position"
            sortDirection = "desc"
        case .newest:
            sortOption = "created_at"
            sortDirection = "desc"
        case .oldest:
            sortOption = "created_at"
            sortDirection = "asc"
        }
        
        guard let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)/contents?page=\(currentPage)&sort=\(sortOption)&direction=\(sortDirection)") else {
            self.isContentsLoading = false
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
                    let newChannelContent = try decoder.decode(ArenaChannelContents.self, from: data)
                    DispatchQueue.main.async {
                        if self.channel != nil, !refresh {
                            if self.contents == nil {
                                self.contents = []
                            }
                            self.contents!.append(contentsOf: newChannelContent.contents ?? [])
                        } else {
                            self.contents = newChannelContent.contents
                        }
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
                self.isContentsLoading = false
            }
        }
        
        task.resume()
    }
}
