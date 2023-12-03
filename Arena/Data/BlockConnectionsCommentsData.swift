//
//  BlockConnectionsComments.swift
//  Arena
//
//  Created by Yihui Hu on 2/12/23.
//

import Foundation
import SwiftUI
import Defaults

class BlockConnectionsData: ObservableObject {
    @Published var connections: [BlockConnection] = []
    @State private var isLoading: Bool = false
    
    func fetchBlockConnections(blockId: Int, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        guard let url = URL(string: "https://api.are.na/v2/blocks/\(blockId)") else {
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [unowned self] (data, _, error) in
            if let data = data {
                do {
                    let blockConnections = try JSONDecoder().decode(BlockConnections.self, from: data)
                    DispatchQueue.main.async {
                        self.connections = blockConnections.connections
                        completion(true)
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding connections data: \(error)")
                    completion(false)
                    self.isLoading = false
                }
            } else if let error = error {
                print("Error fetching connections: \(error)")
                completion(false)
                self.isLoading = false
            }
        }.resume()
    }
}

class BlockCommentsData: ObservableObject {
    @Published var comments: [BlockComment] = []
    @State private var isLoading: Bool = false
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    func fetchBlockComments(blockId: Int, completion: @escaping (Bool) -> Void) {
        var allComments: [BlockComment] = []
        currentPage = 1
        totalPages = 1
        
        func fetchData() {
            isLoading = true
            
            guard let url = URL(string: "https://api.are.na/v2/blocks/\(blockId)/comments?page=\(currentPage)") else {
                self.isLoading = false
                completion(false)
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { [unowned self] (data, _, error) in
                if let data = data {
                    do {
                        let blockComments = try JSONDecoder().decode(BlockComments.self, from: data)
                        DispatchQueue.main.async {
                            allComments.append(contentsOf: blockComments.comments)
                            self.totalPages = Int(ceil(Double(blockComments.length) / Double(20)))
                            self.currentPage += 1
                            
                            if self.currentPage <= self.totalPages {
                                fetchData()
                            } else {
                                self.comments = allComments.reversed()
                                completion(true)
                                self.isLoading = false
                            }
                        }
                    } catch {
                        print("Error decoding comments data: \(error)")
                        completion(false)
                        self.isLoading = false
                    }
                } else if let error = error {
                    print("Error fetching comments: \(error)")
                    completion(false)
                    self.isLoading = false
                }
            }.resume()
        }
        
        fetchData()
    }
}
