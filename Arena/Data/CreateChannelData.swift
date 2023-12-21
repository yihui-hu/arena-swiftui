//
//  CreateChannelData.swift
//  Arena
//
//  Created by Yihui Hu on 13/12/23.
//

import Foundation
import Defaults

enum CreateChannelResult {
    case success(channelSlug: String)
    case failure(error: String)
}

func createChannel(channelTitle: String, channelDescription: String, channelStatus: String, completion: @escaping (CreateChannelResult) -> Void) async {
    var status = "open"
    switch channelStatus {
    case "Open":
        status = "public"
    case "Closed":
        status = "closed"
    case "Private":
        status = "private"
    default:
        status = "private"
    }
    let body: [String: Any] = ["title": channelTitle, "description": channelDescription, "status": status]
    let httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    DispatchQueue.global().async {
        guard let url = URL(string: "https://api.are.na/v2/channels") else {
            DispatchQueue.main.async {
                completion(.failure(error: "Invalid URL"))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    completion(.failure(error: "URLSession invalid"))
                }
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let channelSlug = (json as? [String: Any])?["slug"] as? String {
                    completion(.success(channelSlug: channelSlug))
                } else {
                    completion(.failure(error: "Unable to find channelSlug"))
                }
            } catch {
                completion(.failure(error: "Unable to resolve JSON response"))
            }
        }
        task.resume()
    }
}
