//
//  ChannelFetcher.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import Foundation

class ChannelData: ObservableObject {
    @Published var channel: ArenaChannel?
    @Published var contents: [Block]?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selection: String = "Newest First"
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    init(channelSlug: String, selection: String) {
        self.selection = selection
        fetchChannel(channelSlug)
        fetchChannelContents(channelSlug)
    }
    
    func loadMore(channelSlug: String) {
        fetchChannelContents(channelSlug)
    }
    
    func refresh(channelSlug: String) {
        channel = nil
        contents = nil
        currentPage = 1
        totalPages = 1
        fetchChannel(channelSlug)
        fetchChannelContents(channelSlug)
    }
    
    func fetchChannel(_ channelSlug: String) {
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
    
    func fetchChannelContents(_ channelSlug: String) {
        // Check if we've finished fetching all pages
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }
        
        self.isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.are.na/v2/channels/\(channelSlug)/contents?page=\(currentPage)&sort=created_at&direction=\(selection == "Newest First" ? "desc" : "asc")") else {
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
                    let newChannelContent = try decoder.decode(ArenaChannelContents.self, from: data)
                    DispatchQueue.main.async {
                        if self.channel != nil {
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
                self.isLoading = false
            }
        }
                            
                            task.resume()
                            }
                            }
