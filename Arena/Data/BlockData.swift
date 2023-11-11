//
//  BlockData.swift
//  Arena
//
//  Created by Yihui Hu on 14/10/23.
//

import Foundation

final class BlockData: ObservableObject {
    @Published var block: Block?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init(blockId: Int) {
        fetchBlock(blockId)
    }
    
    final func refresh(blockId: Int) {
        block = nil
        fetchBlock(blockId)
    }
    
    final func fetchBlock(_ blockId: Int) {
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.are.na/v2/blocks/\(blockId)") else {
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
                    let newBlock = try decoder.decode(Block.self, from: data)
                    DispatchQueue.main.async {
                        self.block = newBlock
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
