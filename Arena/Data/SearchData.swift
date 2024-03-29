//
//  SearchData.swift
//  Arena
//
//  Created by Yihui Hu on 19/10/23.
//

import Foundation
import Defaults

final class SearchData: ObservableObject {
    @Published var searchResults: ArenaSearchResults?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchTerm: String = ""
    @Published var selection: String = "Blocks"
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    // MARK: - Search init
    init() {
        if searchTerm != "" {
            fetchSearchResults()
        } else {
            reset()
        }
    }
    
    // MARK: - Fetch more content
    final func loadMore() {
        print("Fetching more search results: page \(self.currentPage) of \(self.totalPages)")
        if searchTerm != "" {
            fetchSearchResults()
        } else {
            reset()
        }
    }
    
    // MARK: - Refresh search results
    final func refresh() {
        reset()
        if searchTerm != "" {
            fetchSearchResults()
        }
    }
    
    final func reset() {
        searchResults = nil
        currentPage = 1
        totalPages = 1
    }
    
    // MARK: - Fetch search results
    final func fetchSearchResults() {
        guard currentPage <= totalPages else {
            return
        }
        
        guard !isLoading else {
            return
        }
        
        self.isLoading = true
        errorMessage = nil
        
        let option: String = switch selection {
        case "Channels":
            "channels"
        case "Blocks":
            "blocks"
        case "Users":
            "users"
        default:
            "channels"
        }
        
        let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        guard let url = URL(string: "https://api.are.na/v2/search/\(option)?q=\(encodedSearchTerm ?? searchTerm)&page=\(currentPage)&per=20") else {
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
                    let searchResults = try decoder.decode(ArenaSearchResults.self, from: data)
                    DispatchQueue.main.async {
                        if self.searchResults != nil {
                            self.searchResults?.channels.append(contentsOf: searchResults.channels)
                            self.searchResults?.blocks.append(contentsOf: searchResults.blocks)
                            self.searchResults?.users.append(contentsOf: searchResults.users)
                        } else {
                            self.searchResults = searchResults
                        }
                        self.totalPages = searchResults.totalPages
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
