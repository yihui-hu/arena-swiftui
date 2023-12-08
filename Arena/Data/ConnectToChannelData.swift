//
//  ConnectToChannel.swift
//  Arena
//
//  Created by Yihui Hu on 5/12/23.
//

import Foundation
import Defaults

func connectToChannel(channels: [String], id: Int, type: String, completion: @escaping () -> Void) async {
    let dispatchGroup = DispatchGroup()
    let body: [String: Any] = ["connectable_id": id, "connectable_type": type]
    let httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    for channel in channels {
        dispatchGroup.enter()
        
        // Inside the group, initiate each API call in a separate queue
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channel)/connections") else {
                dispatchGroup.leave()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            request.httpBody = httpBody
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(channel) done")
                if let responseJSON = responseJSON as? [String: Any] {
                    print("Response: \(channel) done")
                }
            }
            task.resume()
        }
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Notify the completion handler when all tasks are finished
    dispatchGroup.notify(queue: .main) {
        completion()
    }
}

func connectTextToChannel() async {
    
}

func connectImagesToChannel() async {
    
}

func connectLinkToChannel() async {
    
}

func connectFileToChannel() async {
    
}
