//
//  ExploreData.swift
//  Arena
//
//  Created by Yihui Hu on 17/12/23.
//

import Foundation
import Defaults

final class ExploreData: ObservableObject {
    @Published var exploreResults: ArenaExploreResults?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selection: String = "Blocks"
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    // MARK: - Search init
    init() {
        fetchExploreResults()
    }
    
    // MARK: - Fetch more content
    final func loadMore() {
        print("Fetching more explore results: page \(self.currentPage) of \(self.totalPages)")
        fetchExploreResults()
    }
    
    // MARK: - Refresh explore results
    final func refresh() {
        reset()
        fetchExploreResults()
    }
    
    final func reset() {
        exploreResults = nil
        currentPage = 1
        totalPages = 1
    }
    
    // MARK: - Fetch search results
    final func fetchExploreResults() {
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
        
        guard let url = URL(string: "https://api.are.na/v2/search/explore?sort=random&filter=\(option)&per=20") else {
            self.isLoading = false
            errorMessage = "Invalid URL"
            return
        }
        
        print(url)
        
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
                    let exploreResults = try decoder.decode(ArenaExploreResults.self, from: data)
                    DispatchQueue.main.async {
                        if self.exploreResults != nil {
                            self.exploreResults?.channels.append(contentsOf: exploreResults.channels)
                            self.exploreResults?.blocks.append(contentsOf: exploreResults.blocks)
                            self.exploreResults?.users.append(contentsOf: exploreResults.users)
                        } else {
                            self.exploreResults = exploreResults
                        }
                        self.totalPages = exploreResults.totalPages
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
