//
//  UserData.swift
//  Arena
//
//  Created by Yihui Hu on 10/11/23.
//

import Foundation

final class UserData: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init(userId: Int) {
        fetchUser(userId)
    }
    
    final func refresh(userId: Int) {
        fetchUser(userId)
    }
    
    final func fetchUser(_ userId: Int) {
        guard !isLoading else {
            return
        }

        self.isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.are.na/v2/users/\(userId)") else {
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
                    let userData = try decoder.decode(User.self, from: data)
                    DispatchQueue.main.async {
                        self.user = userData
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
