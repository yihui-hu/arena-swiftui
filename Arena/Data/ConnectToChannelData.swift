//
//  ConnectToChannel.swift
//  Arena
//
//  Created by Yihui Hu on 5/12/23.
//

import Foundation
import SwiftUI
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
                print("Response: \(channel) done with \(String(describing: responseJSON))")
            }
            task.resume()
        }
    }
    
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    // Notify the completion handler when all tasks are finished
    dispatchGroup.notify(queue: .main) {
        completion()
        Defaults[.connectSheetOpen] = false
        Defaults[.toastMessage] = "Connected!"
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
    }
}

func connectTextToChannel(channels: [String], text: String, title: [String], description: [String], completion: @escaping () -> Void) async {
    let dispatchGroup = DispatchGroup()
    
    for channel in channels {
        dispatchGroup.enter()
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channel)/blocks") else {
                dispatchGroup.leave()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            let payload: [String: Any] = [
                "content": text,
                "title": title[0],
                "description": description[0]
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            } catch {
                print("Error creating JSON payload: \(error)")
                dispatchGroup.leave()
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(channel) done with \(String(describing: responseJSON))")
            }
            task.resume()
        }
    }
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    dispatchGroup.notify(queue: .main) {
        completion()
        Defaults[.connectSheetOpen] = false
        Defaults[.toastMessage] = "Connected!"
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
    }
}

func connectImagesToChannel(channels: [String], selectedPhotosData: [Data], titles: [String], descriptions: [String], completion: @escaping () -> Void) async {
    let dispatchGroup = DispatchGroup()
    
    for channel in channels {
        dispatchGroup.enter()
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channel)/blocks") else {
                dispatchGroup.leave()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            for imageData in selectedPhotosData {
//                let image = UIImage(data: imageData)
                
                let payload: [String: Any] = [
                    "source": imageData.base64EncodedString(),
                    "content": "",
                    "title": "test title",
                    "description": "test description"
                ]
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
                } catch {
                    print("Error creating JSON payload: \(error)")
                    dispatchGroup.leave()
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(channel) done with \(String(describing: responseJSON))")
                }
                task.resume()
            }
        }
    }
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    dispatchGroup.notify(queue: .main) {
        completion()
        Defaults[.connectSheetOpen] = false
        Defaults[.toastMessage] = "Connected!"
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
    }
}


func connectLinksToChannel(channels: [String], links: [String], title: [String], description: [String], completion: @escaping () -> Void) async {
    let dispatchGroup = DispatchGroup()
    
    for channel in channels {
        dispatchGroup.enter()
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.are.na/v2/channels/\(channel)/blocks") else {
                dispatchGroup.leave()
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(Defaults[.accessToken])", forHTTPHeaderField: "Authorization")
            
            let payload: [String: Any] = [
                "source": links[0],
                "title": title[0],
                "description": description[0]
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            } catch {
                print("Error creating JSON payload: \(error)")
                dispatchGroup.leave()
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(channel) done with \(String(describing: responseJSON))")
            }
            task.resume()
        }
    }
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    
    dispatchGroup.notify(queue: .main) {
        completion()
        Defaults[.connectSheetOpen] = false
        Defaults[.toastMessage] = "Connected!"
        Defaults[.showToast] = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Defaults[.showToast] = false
        }
    }
}

func connectFileToChannel() async {
    
}
